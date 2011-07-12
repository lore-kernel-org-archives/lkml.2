Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab1GLPnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 11:43:51 -0400
Received: from smtp107.prem.mail.ac4.yahoo.com ([76.13.13.46]:28345 "HELO
	smtp107.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751267Ab1GLPnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 11:43:50 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Beb5c9IVM1mRvEd78TIFSmE1V_x.U50KjY8PUjP4H0IbkkH
 awx5GU_S9WoOhgmUdKZQjBE.pUK_Q3KdMfgg7y9d02zTGQCN1FBRocRj8uyp
 w.n609yQFas3BSq00KizYYRatwVRDUxPR39NskgE.DNspBR2530FzMtSAj.e
 6maQF7UwkbjcYnk51rEpHlcs_UIogUG29vn1bcGmbd9MZ4q_0scE52n.plUU
 cxsBOSixwOgQkaeqhew105v41W8dmms97EutDGENH0DilGIjhFsGuhgevIYD
 LJzckXphxW573UqWDl52ozENfcC4Sb87PqO6t0Ttxx5qkogJ_8QyDAo2oshA
 MVYK6EVA.0vm64JHT8ooxEq6n
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 12 Jul 2011 10:43:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Minchan Kim <minchan.kim@gmail.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, mgorman@suse.de,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: vmscan: Do use use PF_SWAPWRITE from
 zone_reclaim
In-Reply-To: <CAEwNFnAprEuZJucDSMgnUHGePyxgyRqNCWOsG0-K2nTjmKcUug@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1107121042240.2530@router.home>
References: <1310389274-13995-1-git-send-email-mgorman@suse.de> <1310389274-13995-2-git-send-email-mgorman@suse.de> <CAEwNFnATXiQsmbfuvZNEtcpcVZkyZKRFB1SKbkEREaCW4S-aUg@mail.gmail.com> <4E1C1684.4090706@jp.fujitsu.com>
 <CAEwNFnAprEuZJucDSMgnUHGePyxgyRqNCWOsG0-K2nTjmKcUug@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011, Minchan Kim wrote:

> If I am not against this patch, at least, we need agreement of
> Christoph and others and if we agree this change, we changes vm.txt,
> too.

I think PF_SWAPWRITE should only be set if may_write was set earlier in
__zone_reclaim. If zone reclaim is not configured to do writeback then it
makes no sense to set the bit.

