Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1GTSIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 14:08:51 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44304 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751822Ab1GTSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 14:08:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: G2n77aIVM1mVak5WyBXbAiIBCVvvO0nVzjhGgajKhc5Ut5l
 lARgRY50OCSeUOekoVkN4HPIKd4nKN5XHyRRW_vTaU_H9y_orNOVFQfpsrY3
 qpGy.9_sJmhnlTd2QK3Hz3O8dbcuy7AJJifS3cKzHjgOduTM.VPKunPCuwhI
 NPU98gf19I27hquLJg549ZU1yzh.3GWA1tbaJqWMFrF92AwO0yNN2xBambmP
 nKC76lITDtG7bFj9Qojg3k9qDIzNr_UeNK6OPfLwKoCkB3N98EbXRGVV4YSK
 28qJXNPMTjhdZkwoxED4Qe587G0OQHN1YWTxuarHWNiznoe2HfhqZRBCEKFY
 nUEKl_eBqyAk3S9AZ2iXmbg4-
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 20 Jul 2011 13:08:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
In-Reply-To: <alpine.DEB.2.00.1107190901120.1199@router.home>
Message-ID: <alpine.DEB.2.00.1107201307530.1472@router.home>
References: <1310742540-22780-1-git-send-email-mgorman@suse.de> <1310742540-22780-2-git-send-email-mgorman@suse.de> <alpine.DEB.2.00.1107180951390.30392@router.home> <20110718160552.GB5349@suse.de> <alpine.DEB.2.00.1107181208050.31576@router.home>
 <20110718211325.GC5349@suse.de> <alpine.DEB.2.00.1107181651000.31576@router.home> <alpine.DEB.2.00.1107190901120.1199@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm... Looking at get_page_from_freelist and considering speeding that up
in general: Could we move the whole watermark logic into the slow path?
Only check when we refill the per cpu queues?

