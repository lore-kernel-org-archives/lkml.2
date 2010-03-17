Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0CQRFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:05:09 -0400
Received: from lo.gmane.org ([80.91.229.12]:59375 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab0CQRFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:05:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: ATA 4 KiB sector issues.
Date: Wed, 17 Mar 2010 13:04:48 -0400
Message-ID: <hnr23h$pq$1@dough.gmane.org>
References: <4B947393.2050002@kernel.org> <201003100046.24695.arnd@arndb.de>	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>	 <4B9EED55.10201@kernel.org> <1268720060.21384.10.camel@mulgrave.site>	 <4B9F2388.2030803@kernel.org> <1268745897.21384.14.camel@mulgrave.site>	 <4B9F8E1A.2020608@kernel.org> <1268749297.21384.15.camel@mulgrave.site>	 <4B9F9AAF.6080709@kernel.org> <1268751748.21384.18.camel@mulgrave.site> <4B9FA1C6.7090305@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: pool-68-236-149-162.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 NOT Firefox/3.0.11 pango-text SeaMonkey/1.1.16
In-Reply-To: <4B9FA1C6.7090305@kernel.org>
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On 03/17/2010 12:02 AM, James Bottomley wrote:
>> On Tue, 2010-03-16 at 23:50 +0900, Tejun Heo wrote:
>>> e.g.  If the first partition begins at CHS 0/32/33 and ends at
>>> 12/233/19 and the corresponding LBA addresses are 2048 and 206848, you
>>> can solve the equation and determine that the parameters gotta be 63
>>> secs/trk and 255 heads/cyl to make those two pairs of addresses match
>>> each other and in fact some BIOSs try to do this depending on
>>> configuration (and sometimes falls into infinite loop or causes other
>>> boot related problems if the parameters are too uncommon).
>> for an msdos label, this is illegal, that was Arnd's point.  The
>> partitions have to begin and end on cylinder boundaries*.  Knowing that,
>> you can deduce the geometry from the last sector entry.
>>
>> * at least if you want to preserve windows compatibility, which is what
>> most of our partitioning tools seem to do.
> 
> Well, the thing is that
> 
> * Anything remotely modern (>= XP) doesn't give a hoot about cylinder
>   alignment.
> 
> * Anything older (<= 2000) is very likely to get confused with custom
>   geometry starting from the BIOS itself.  For those cases, the only
>   thing we can do is aligning partitions to cylinders abiding BIOS
>   supplied geometry parameters which will usually be 255/63.
> 
> So, using custom geometry doesn't help compatibility at all.
> 
I think you hit on the real culprit and ignored it, it seems that even modern 
BIOS implementations, at least some of them, do not want to cross a cylinder 
boundary doing boot. Or maybe that's dumb MBR code, which at least has the 
excuse of being size limited.

I did try using 48 sector geometry on a virtual drive, and it seems as though 
both Linux and XP will install. Then I tried on a USB stick and the BIOS in 
several old Asus laptops will boot that.

I cautiously suggest that since nothing past boot used chs, and using 48 spt 
seems to work and gives correct alignment, perhaps there is value in custom 
geometry.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

