Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab1BHOcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:32:07 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:36747 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1BHOcE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:32:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lx2AabADGJMNcjPvX4jCa5djL3x2Jdm5i2MgbUjlqVuvoGsFZDhc7x7XStd2Almu/t
         VKFYkdnDECFK4U4PahbUtca/Qul5F9ojuR5W4W2AqRyE3/QR8i35fJcvQJ1e+SXIdXQ4
         j6i8urCErL6tlg/orK+n2B5z5TH1GTmXSmNhU=
MIME-Version: 1.0
In-Reply-To: <20110208141239.28d80615@lxorguk.ukuu.org.uk>
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>
	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>
	<20110208130701.19709cc6@lxorguk.ukuu.org.uk>
	<AANLkTimAioh_xu0qoQCndSWDAYJ4bpWv01NZn_bZ9g2a@mail.gmail.com>
	<20110208132518.300bb098@lxorguk.ukuu.org.uk>
	<AANLkTimYbC+zgnct9j75WNR7f4M4m2=hYvODUm9mc-3W@mail.gmail.com>
	<20110208133922.6cf8142e@lxorguk.ukuu.org.uk>
	<AANLkTik744+r8y1FK9P6-aOcH0OMLyg5nvfJb2ZBVSdv@mail.gmail.com>
	<20110208141239.28d80615@lxorguk.ukuu.org.uk>
Date: Tue, 8 Feb 2011 15:32:03 +0100
Message-ID: <AANLkTim7VvcBikPW2vHwyfpaodF23btcbp6dYLvhwKQY@mail.gmail.com>
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 8, 2011 at 3:12 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> respect some of my time spent on all this burdensome silly little
>> driver differences comparisons and read the whole patch set before
>> making comments on individual changes (which you certainly haven't
>> done given timing of your review mails and complexity of changes)..
>
> I was hoping you'd improved but apparently not.

I'm not the person who doesn't change..

> Any untested change is dangerous. An untested change that merges drivers
> together simply means you can break lots of stuff for no gain at all.

This is why patches were posted to mailing list with a request for a
real hardware testing:

"All testing was done using QEMU's PIIX3 controller emulation so any testing
with real EFAR, IT8213, old PIIX, RDC and Radisys R82600 PATA controllers
would be really appreciated.."

instead of request for a merge.  It was all there in initial mail.

Besides decreased complexity,1400 LOC gone and 5 drivers removed
cannot be really called "no gain at all".

> If these were all PCI card devices it might make some sense but given
> they are all motherboard chipsets putting them into one driver merely
> increases memory use as well.

We can improve situation here by doing generic ATA or SCSI changes
instead, not worth keeping separate drivers when you make similar
effect but more maintainable and generic changes.

> As far as stuff like
>
>    unsigned int has_sitre  = (dev->vendor != 0x8086 ||
>                                   dev->device != 0x1230);
>
> and the even worse mess you generate with the added patch all the other
> PIIX code does this by flags, and if you had a HAS_SITRE (or NO_SITRE)
> flag in the device data it would be obvious to anyone reading stuff how
> it all fitted together.

Now that's what is a real review work.  It will be changed in the next
revision, thanks!

-- Bartlomiej
