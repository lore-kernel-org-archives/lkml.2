Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0IFMdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:33:44 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:34211 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0IFMdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:33:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ENhuuZ/1P4EdBFgyPJ2tu0iwGPJmcOLIX0NNlF3BRBadWLIHOsGxpK4s+rZojAx2TP
         09sAdzceJqcfzCoqR5tTv/Wa5vNWeGw6/tLkKSEstQOsKGB2Yyt5bg6fRR3t7rzobToF
         Z7zbtMxuVEUGIMKWguY3t9ByAtRPDtyUKfLJ0=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=xaTdjrb3ZO5dU+bY_GpaBE4F2-0gFmN=SykD5@mail.gmail.com>
References: <AANLkTimSsj5eW1Vy3g7S0XCKRcZ0fZ0jQ6_9VpjVMYcj@mail.gmail.com>
	<20100903140041.GA16223@kroah.com>
	<AANLkTi=xaTdjrb3ZO5dU+bY_GpaBE4F2-0gFmN=SykD5@mail.gmail.com>
Date: Mon, 6 Sep 2010 14:33:42 +0200
Message-ID: <AANLkTi=f0Am-iMZM=xU5_Hqw4ni1effrqhUxpKE9opFj@mail.gmail.com>
Subject: Re: Crash on reducing the kernel mem.
From: Martin Fuzzey <mfuzzey@gmail.com>
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kernelnewbies@nl.linux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 6, 2010 at 12:47 PM, Prabhu Chawandi
<prabhu.chavandi@gmail.com> wrote:
> Hi Greg,
>
>  I am specifying the memory as part of command line parameter "mem=".
> I know only that what ever amount specify against "mem=" will be a
> kernel memory and rest is used for the drivers.
>
No it doesn't work like that.

Setting mem= will reduce the total amount of memory used.
If your system has 256M and you specify mem=128M the result
is that the other 128M is unused.

The kernel makes no separation between "kernel" and "drivers".
Drivers are part of the kernel (ie they live in the same address
space and can touch any memory).

There is a separation between kernel and userspace (ie
userspace processes cannot touch each others memory nor kernel
memory). However even the "userspace memory" comes from
the same "pool" reduced by mem=.

So when you changed mem=128M to mem=110M (intending
to give more memory to "drivers") what you actually did was
to reduce the memory available to the system. If that causes
a crash its likely just not enough memory available, probably
nothing specific to USB just that's where it happens to run out.

Why are you reducing memory in this way?
Normally the bootloader knows / detects how much memory
is available and informs the kernel. Reducing it is generally
only done for testing purposes (such as the case where you
have a development board that has more memory than the
production unit will so you artificially reduce the available
memory to see how it will behave on a production board).

Hope this helps,

Regards,
Martin
