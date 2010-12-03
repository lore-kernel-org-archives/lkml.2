Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab0LCMpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:45:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58889 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932494Ab0LCMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:45:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bYPS5a7VK6yNgVtagjKT9iTa73TQsOK0ixmuMxbl391iFoWjOwBMycBnnT5EdV5dQx
         1n9oVZSLl9PE8wDifLkUqOOC1MR/1vfvZK1BTBQyA1lPvtN5wK7cn4xm2w2wdQG/VYjA
         SW8AysIbF/jD8o+U4X9JbsS/IGougaz/7/RXg=
Subject: Re: sata_sil24: external raid storage mistaken as port multiplier
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Tejun Heo <tj@kernel.org>, Mark Lord <kernel@teksavvy.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1290941518.12616.12.camel@Tobias-Karnat>
References: <1290461073.12443.21.camel@Tobias-Karnat>
	 <1290514125.28293.2.camel@Tobias-Karnat>
	 <1290572588.24847.20.camel@Tobias-Karnat> <4CEFEC17.6060503@kernel.org>
	 <4CF014F8.9000700@teksavvy.com> <4CF01583.5050307@kernel.org>
	 <4CF07386.7080304@teksavvy.com>  <1290941518.12616.12.camel@Tobias-Karnat>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Dec 2010 13:45:44 +0100
Message-ID: <1291380344.23852.9.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 28.11.2010, 11:51 +0100 schrieb Tobias Karnat:
> Am Freitag, den 26.11.2010, 18:19 +0100 schrieb Tejun Heo:
> > That said, yeah, it probably would be a good idea to add a
> > libata.force param.
> > 
> > Can you please apply the following patch and verify that the device
> > doesn't work without any parameter but it does with
> > "libata.force=nopmp"?
> 
> Sorry, but I am currently happy with the generic Ubuntu Kernel
> with the module recompiled.
> 
> Maybe I am just lazy, but I have scheduled to compile my first Kernel
> on Ubuntu 10.10 when 2.6.37 will be out.

Well, I'm now on 2.6.36.1, because I had an problem with Kaffeine and
2.6.37-rc4. But I don't like the idea to force to not use pmp on every
controller. I don't have an pmp which I use, but maybe someone else does
and also has the problem with the external case.

> Am Freitag, den 26.11.2010, 21:57 -0500 schrieb Mark Lord:
> > I suppose *if* we knew the exact fwrev that requires the workaround,
> > then we could make it automatic for that, and still have the boot flag
> > for cases we don't know about.
> > 
> > Tobias?  Got the IDENTIFY info from that device?
> > Something like "hdparm --istdout /dev/sdX"  ?
> 
> Yes, hdparm --istdout /dev/sdh gives,
> 
> /dev/sdh:
> 0040 3fff c837 0010 0000 0000 003f 0000
> 0000 0000 3037 3043 3035 465f 3837 3933
> 3931 5f5f 5f30 5f38 0003 3e00 0004 5247
> 4c31 3034 3033 4578 7465 726e 616c 2044
> 6973 6b20 3020 2020 2020 2020 2020 2020
> 2020 2020 2020 2020 2020 2020 2020 8001
> 0000 2f00 4000 0200 0000 0006 0000 0000
> 0000 0000 0000 0101 ffff 0fff 0000 0407
> 0003 0078 0078 0078 0078 0000 0000 0000
> 0000 0000 0000 0000 0201 0000 0000 0000
> 007e 001b 0069 7460 4040 0028 3460 4040
> 207f 0000 0000 0000 fffe 0000 c0fe 0000
> 0000 0000 0000 0000 c060 7470 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0001 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0017 2040
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 0000
> 0000 0000 0000 0000 0000 0000 0000 a3a5

I hope this is enough info?

-Tobias

