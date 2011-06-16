Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1FPCa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 22:30:57 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:52846 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752594Ab1FPCa4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 22:30:56 -0400
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
Date: Wed, 15 Jun 2011 19:29:18 -0700
Subject: RE: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Topic: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Thread-Index: AcwrIR/qdpMMo2uOTdi6EtZ/SnmPkgAAZ5KAACgYoPAAAOfC4AABCYdAAABOEGA=
Message-ID: <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com>
 <1308065367.2401.24.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com>
 <1308117450.2329.31.camel@mulgrave>
 <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com>
 <637AF86F1A314F15B816411A580575F0@usish.com.cn>
 <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com>
 <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
In-Reply-To: <51A55E816E3847EF97FE4E849A572717@usish.com.cn>
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

> [Jack Wang] 
>It's the same, sas_ex_get_linkrate use DISCOVER response as linkrate.
But the function have problem, actually, the error statement is:
child->linkrate = min(parent_phy->linkrate, child->max_linkrate); 
its mean like this:
child->linkrate = min(child_phy->linkrate, max(parent->max_linkrate,child_phy->linkrate));
and if parent->max_linkrate(3Gbps) is less than child_phy->linkrate(6Gbps),
the statement will be change this:
child->linkrate = child_phy->linkrate, forget the parent linkrate.

