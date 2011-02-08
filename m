Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1BHOBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:01:49 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40872 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab1BHOBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:01:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h/M1Dp7IPmCgdWcAPgleR6rN/KYMtLfqoj0hxGzt+tm1BXc0WoV8OjO9INc/XuvAwd
         +P7J16nHFzXHuzsxN4PJg8T4hDKQ9FKEwWu/en8sliuaEPYNcVQg/tAA+D7wW+GAppuG
         wlGF3caRAslTiL1fBOR7hNthpQI0Aygsvtk8c=
MIME-Version: 1.0
In-Reply-To: <20110208133809.2386ee86@lxorguk.ukuu.org.uk>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122534.19110.89437.sendpatchset@linux-mhg7.site>
	<20110208131321.6ceb9a43@lxorguk.ukuu.org.uk>
	<AANLkTikYXWAbCjLpSyEqgDKBsZuM1na-tohLoLJx3Yr4@mail.gmail.com>
	<20110208133809.2386ee86@lxorguk.ukuu.org.uk>
Date: Tue, 8 Feb 2011 15:01:45 +0100
Message-ID: <AANLkTimGRnOkBJWiGejonRKGVp5urXDNwa8DKovhNSt0@mail.gmail.com>
Subject: Re: [PATCH 16/20] ata_piix: add EFAR SLC90E66 support
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 2:38 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> such optimizations because maintenance cost > potential savings (i.e.
>> making SCSI quirks optional, I have draft patch for this, itself cuts
>> like 10k).
>
> Interesting in itself but irrelevant because the current situation is
> that a piix change cannot break oldpiix, efar, it8213, radisys etc and
> vice versa. Particuarly important when the other chips are not common so
> test coverage is difficult, and that far outweighs the maintenance
> savings for other things, especially as this is code that just doesn't
> change.
>
>>
>> > It also leads to hideous uglies in the main code paths like this :
>> >
>> > +       unsigned int has_sitre  = (dev->vendor != 0x8086 ||
>> > +                                  dev->device != 0x1230);
>> >
>> > which also has exactly zero comments.
>>
>> has_sitre variable name is documentation in itself for anyone knowing
>> the hardware or has read a chipset/code documentation.
>
> And naturally anyone randomly glancing at the code knows why it's
> checking 0x8086 & 0x1230, and why the radisys check interacts with it.
>
> Bartlomiej - those are a mess, a complete and total mess. It doesn't
> necessarily argue against folding them together, but at least do a clean
> job of it.

I beg to differ regardless "the mess" comment but well, you can always
take my work and "add value" to it like in 2009 (when somehow you miss
that your pata_rdc also needs locking fixes but you were more
concerned with little differences between my work and your
"dreamwork"..)
