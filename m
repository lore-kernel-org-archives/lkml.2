Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0CPPSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:18:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:38950 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab0CPPSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:18:21 -0400
Message-ID: <4B9FA1C6.7090305@kernel.org>
Date: Wed, 17 Mar 2010 00:20:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Denys Vlasenko <vda.linux@googlemail.com>, Arnd Bergmann <arnd@arndb.de>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>	 <4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>	 <4B9F2388.2030803@kernel.org> <1268745897.21384.14.camel@mulgrave.site>	 <4B9F8E1A.2020608@kernel.org> <1268749297.21384.15.camel@mulgrave.site>	 <4B9F9AAF.6080709@kernel.org> <1268751748.21384.18.camel@mulgrave.site>
In-Reply-To: <1268751748.21384.18.camel@mulgrave.site>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 15:17:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 12:02 AM, James Bottomley wrote:
> On Tue, 2010-03-16 at 23:50 +0900, Tejun Heo wrote:
>> e.g.  If the first partition begins at CHS 0/32/33 and ends at
>> 12/233/19 and the corresponding LBA addresses are 2048 and 206848, you
>> can solve the equation and determine that the parameters gotta be 63
>> secs/trk and 255 heads/cyl to make those two pairs of addresses match
>> each other and in fact some BIOSs try to do this depending on
>> configuration (and sometimes falls into infinite loop or causes other
>> boot related problems if the parameters are too uncommon).
> 
> for an msdos label, this is illegal, that was Arnd's point.  The
> partitions have to begin and end on cylinder boundaries*.  Knowing that,
> you can deduce the geometry from the last sector entry.
>
> * at least if you want to preserve windows compatibility, which is what
> most of our partitioning tools seem to do.

Well, the thing is that

* Anything remotely modern (>= XP) doesn't give a hoot about cylinder
  alignment.

* Anything older (<= 2000) is very likely to get confused with custom
  geometry starting from the BIOS itself.  For those cases, the only
  thing we can do is aligning partitions to cylinders abiding BIOS
  supplied geometry parameters which will usually be 255/63.

So, using custom geometry doesn't help compatibility at all.

Thanks.

-- 
tejun
