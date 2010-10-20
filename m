Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab0JTVbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:31:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55845 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0JTVbn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:31:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NQY1T/5rbd6gqSa+gUj/sfugFhdGxe0IZq6IWGrZFmOPGuIYDpQ+2lr14IAFItXSJh
         jdDaVqA00a0GWTZOqnz7ZBoDn/0bFNX9n/xxUeo06tpAQ9UoV2HL5u+0buhmWXpBIy3S
         41VB4qGNIDAWZ/Uex6n6zWGJr/zQ3loqbZ560=
MIME-Version: 1.0
In-Reply-To: <20101020211643.GA10006@suse.de>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
	<1287608139-21354-2-git-send-email-alchark@gmail.com>
	<20101020211643.GA10006@suse.de>
Date: Thu, 21 Oct 2010 01:31:41 +0400
Message-ID: <AANLkTikGiYvXgLs5eRQ9ghmatccBQJSdS3qwEHZN_3NF@mail.gmail.com>
Subject: Re: [PATCH 2/6] serial: Add support for UART on VIA VT8500 and compatibles
From: Alexey Charkov <alchark@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/21 Greg KH <gregkh@suse.de>:
> On Thu, Oct 21, 2010 at 12:55:34AM +0400, Alexey Charkov wrote:
>> This adds a driver for the serial ports found in VIA and WonderMedia
>> Systems-on-Chip. Interrupt-driven FIFO operation is implemented.
>> The hardware also supports pure register-based operation (which is
>> slower) and DMA-based FIFO operation. As the FIFOs are only 16 bytes
>> long, DMA operation is probably not worth the hassle.
>>
>> Signed-off-by: Alexey Charkov <alchark@gmail.com>
>> ---
>>
>> Please review and state whether this could be acceptable for a merge
>> to mainline in the coming 2.6.37 window.
>
> .37?  Aren't you cutting it a bit close here?  My trees unofficially
> closed a few days or so ago for new stuff to go to .37, what kept this
> from being sent previously?
>

In fact, I'm somewhat new to kernel development, and have not yet
understood the good timings to do things properly. My view was that
the merge window is when new stuff should be submitted, while
everything in between is devoted to fixing breakage just introduced.
So, I must have been wrong :)

>> If possible, I would deeply appreciate a merge to a relevant git tree
>> for integration prior to asking Linus to pull the changes. I could
>> rebase the code if needed, currently this is against Linus' master
>> branch.
>>
>> This patch relies on the basic architecture support for VT8500/WM8505
>> to be in place, as introduced by PATCH 1/6 in this series.
>
> So it will just fail to build without that patch?
>

It won't, and it should not even be selectable, as there is a Kconfig
dependency on the relevant arch. It's just that it would be useless
without the relevant arch support.

> thanks,
>
> greg k-h
>
