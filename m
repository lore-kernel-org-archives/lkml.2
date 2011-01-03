Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1ACUhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:37:19 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39006 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246Ab1ACUhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:37:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=c5Sdn98SxoO+ofZkkdRsxcdzrl2TKMEWLryImYz/x2AupmrT8kQ0zdZDmDSs+r5Y0W
         osUzCr7ZpWGjToak/zMGw9gElJjJs6QB6cL1kbpG+HbIpUvXeIRG1N1hGsWo6dBPGKG9
         jnq+TAU+g8mQkfyuinghlkk44iV1CvQusuHTU=
MIME-Version: 1.0
In-Reply-To: <1294083541.17576.11.camel@lithium>
References: <1294072336.17576.7.camel@lithium>
	<20110103.105827.112602895.davem@davemloft.net>
	<1294083541.17576.11.camel@lithium>
Date: Tue, 4 Jan 2011 06:37:15 +1000
Message-ID: <AANLkTi=trysd5MJR2mtp-89jJiKQ+nhrGVBrwk_Q+2R8@mail.gmail.com>
Subject: Re: Using s3virge card in Sun Blade 2000
From: Dave Airlie <airlied@gmail.com>
To: alex.buell@munted.org.uk
Cc: David Miller <davem@davemloft.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 4, 2011 at 5:39 AM, Alex Buell <alex.buell@munted.org.uk> wrote:
> On Mon, 2011-01-03 at 10:58 -0800, David Miller wrote:
>> From: Alex Buell <alex.buell@munted.org.uk>
>> Date: Mon, 03 Jan 2011 16:32:16 +0000
>>
>> > I'm aware the s3fb driver has big endian issues, I can help fix those
>> > issues so I can get the card working. Or in other words, I'd welcome
>> > advice on how to proceed with this.
>>
>> It's not endian issues, this driver has other problems.
>>
>> It uses the VGA register accessors with a NULL regbase, which is not
>> going to work on sparc64.
>>
>> It needs to access the VGA register space relative to the I/O space
>> of the PCI controller domain it is behind.
>>
>> Probably if you replace the NULL values passes to vga_r*() and
>> vga_w*() with the I/O space resource base of the chip (should be
>> resource "1") it might work.
>
> I've had a look at linux/include/video/vga.h, and yes I see what you
> mean now.
>
> Secondly, is Linux fully capable of handling different graphic cards
> simultaneously? For example, plug in a pair of monitors and have
> consoles on both with disparate graphic cards i.e. XVR-500 and S3ViRGE
> etc?

Not currently, since you would also need some way to sanely route input.

You can put different VTs on different consoles but thats about it.

Dave.
