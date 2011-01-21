Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1AUIE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 03:04:28 -0500
Received: from void.printf.net ([89.145.121.20]:35693 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289Ab1AUIE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 03:04:26 -0500
Date: Fri, 21 Jan 2011 08:04:22 +0000
From: Chris Ball <cjb@laptop.org>
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Message-ID: <20110121080422.GA21763@void.printf.net>
References: <20110120075556.GA23566@intel.com> <20110120161248.GA11774@void.printf.net> <5D8008F58939784290FAB48F5497519835341813A7@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5D8008F58939784290FAB48F5497519835341813A7@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chuanxiao,

On Fri, Jan 21, 2011 at 11:06:08AM +0800, Dong, Chuanxiao wrote:
> Hi Chris,
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-devices-mmc
> > > @@ -0,0 +1,19 @@
> > > +What:
> > 	/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/enhanced_area_offset
> > > +Date:		January 2011
> > > +Contact:	Chuanxiao Dong <chuanxiao.dong@intel.com>
> > > +Description:
> > > +		Enhanced area is a new feature defined in eMMC4.4 standard.eMMC4.4
> > or
> > > +		later card can support such feature. This kind of area can help to
> > > +		improve the card performance. If the feature is enabled, this attribute
> > > +		will indicate the start address of enhanced data area. If not, this
> > > +		attribute will be -EINVAL. Unit Byte. Format decimal.
> > > +
> > > +What:		/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/enhanced_area_size
> > > +Date:		January 2011
> > > +Contact:	Chuanxiao Dong <chuanxiao.dong@intel.com>
> > > +Description:
> > > +		Enhanced area is a new feature defined in eMMC4.4 standard. eMMC4.4
> > or
> > > +		later card can support such feature. This kind of area can help to
> > > +		improve the card performance. If the feature is enabled, this attribute
> > > +		will indicate the size of enhanced data area. If not, this attribute
> > > +		will be -EINVAL. Unit KByte. Format decimal.
> > 
> > This is still wrapped at > 80 columns.
> Sorry for that. I have set the textwidth=80 for vim, not understand why this is still wrapped at >80 columns... I know checkpatch.pl can help us to find the style problem, and is there some other script which can help find the style problem of Document or how can I avoid such errors?

checkpatch.pl will warn about >80 chars, so that should be fine on its own.

> > Oh, and let's mention the units of _offset and _size in the comment in
> > card.h.
>
> Chris, you mean the type of _offset and _size? I think the 64bits number for _offset is enough, also the 32bits number for _size since the units of _size is Kbytes. Any suggestions on that?

Ah, I wasn't clear -- I meant the bytes/kilobytes units, not the data type
sizes.  e.g.:

+   size_t          enhanced_area_size;             /* Units: KB */ 

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
