Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1FPGiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:38:20 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53505 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab1FPGiQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:38:16 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Jack Wang <jack_wang@usish.com>,
        "'James Bottomley'" <James.Bottomley@HansenPartnership.com>
CC: "yxlraid@gmail.com" <yxlraid@gmail.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "maciej.trela@intel.com" <maciej.trela@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jacky Feng <jfeng@marvell.com>
Date: Wed, 15 Jun 2011 23:37:41 -0700
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Topic: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Index: AcwrIR/qdpMMo2uOTdi6EtZ/SnmPkgAAZ5KAACgYoPAAAOfC4AABCYdAAABOEGAAA867gAAA6NjQAAMaV6AAAIc6oA==
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66D88@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
 <637AF86F1A314F15B816411A580575F0@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
 <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com>
 <C8FBA6A948D643679B01520A89FAC48A@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66D1E@SC-VEXCH4.marvell.com>
 <E3CF09ECAD244C00A4C096DB374E140E@usish.com.cn>
In-Reply-To: <E3CF09ECAD244C00A4C096DB374E140E@usish.com.cn>
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

> >[Jack Wang]
> >I don't think the statement below is error:
> >child->linkrate = min(parent_phy->linkrate, child->max_linkrate);

The parent_phy is same to child_phy, I don't think it's right.

>> Yes, you can test like this.
>> >Then expander1's linkrate will set to 3G, and expander2's linkrate will
set
>> >to 6G, that is correct.
>> yes
>> > But the connection rate will be 3G from hba to
>> >expander2.
>> How to configure the connection rate?
>> Now, MVSAS driver get 6G from sas_ex_get_linkrate function, and set
linkrate
>> of OPEN address frame to the value. right?
>> 
>> --
>[Jack Wang] 
>Connection rate is auto, link layer will insert deletable primitives to do
>rate matching (sas2r15 7.14).

>Yes, you should set the linkrate to that value .

OK.MVSAS driver seem right. But, the problem is command fail because of link error, that is why I commit this patch. And my patch work fine.
You can reproduce the issue and fix it. Thanks!

