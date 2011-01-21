Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab1AUJMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 04:12:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:52936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810Ab1AUJMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 04:12:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,357,1291622400"; 
   d="scan'208";a="595121483"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Chris Ball <cjb@laptop.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Fri, 21 Jan 2011 17:12:00 +0800
Subject: RE: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Topic: [PATCH v3 1/1]mmc: implemented eMMC4.4 enhanced area feature
Thread-Index: Acu5QdVlhNhS+s2lR7mXY3YLFbJivgAB4DHA
Message-ID: <5D8008F58939784290FAB48F549751983539F50558@shsmsx502.ccr.corp.intel.com>
References: <20110120075556.GA23566@intel.com>
 <20110120161248.GA11774@void.printf.net>
 <5D8008F58939784290FAB48F5497519835341813A7@shsmsx502.ccr.corp.intel.com>
 <20110121080422.GA21763@void.printf.net>
In-Reply-To: <20110121080422.GA21763@void.printf.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,
> 	/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/enhanced_area_size
> > > > +Date:		January 2011
> > > > +Contact:	Chuanxiao Dong <chuanxiao.dong@intel.com>
> > > > +Description:
> > > > +		Enhanced area is a new feature defined in eMMC4.4 standard.
> eMMC4.4
> > > or
> > > > +		later card can support such feature. This kind of area can help to
> > > > +		improve the card performance. If the feature is enabled, this
> attribute
> > > > +		will indicate the size of enhanced data area. If not, this attribute
> > > > +		will be -EINVAL. Unit KByte. Format decimal.
> > >
> > > This is still wrapped at > 80 columns.
> > Sorry for that. I have set the textwidth=80 for vim, not understand why this is still
> wrapped at >80 columns... I know checkpatch.pl can help us to find the style
> problem, and is there some other script which can help find the style problem of
> Document or how can I avoid such errors?
> 
> checkpatch.pl will warn about >80 chars, so that should be fine on its own.
I have used the checkpatch.pl to check this patch, and no error or warning found....

> 
> > > Oh, and let's mention the units of _offset and _size in the comment in
> > > card.h.
> >
> > Chris, you mean the type of _offset and _size? I think the 64bits number for
> _offset is enough, also the 32bits number for _size since the units of _size is Kbytes.
> Any suggestions on that?
> 
> Ah, I wasn't clear -- I meant the bytes/kilobytes units, not the data type
> sizes.  e.g.:
> 
> +   size_t          enhanced_area_size;             /* Units: KB */
I think the units of _offset and _size should be easy for user to understand, so just choose the Byte for _offset and Kbyte for _size...
And as spec said, the _size is (ENH_SIZE_MULT_2 << 16 + ENH_SIZE_MULT_1 << 8 + ENH_SIZE_MULT_0) x HC_WP_GRP_SIZE x HC_ERASE_GPR_SIZE x 512kBytes. It must be Kbytes aligned. That is another reason to choose it.
What do you think?

Thanks
Chuanxiao
