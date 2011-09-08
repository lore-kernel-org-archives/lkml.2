Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab1IIAEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:04:39 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:47555 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756511Ab1IIAEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:04:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ddUy7goVM1mvqMTzS1Nmlsxh5WDTYcS1c2PFJxs0xSo2eEl
 LwMcgZaN9_BL8.Cvkcv0aWHTCt5cI1kjNiuHP_5ebN0N_EB2rNBS1ahvHGAE
 4Lp0BsPOMzyIxcZVb.72UlaB3yQh0BCcFqNiuiBe4XrScmb6EGY.PQ_udfzA
 Jy3q1lXNwOH.tVSjVOtxSG8UYTnZiN0iaf.VcARn7fJTZyMTKU8emxUIzwIF
 BZ1M.1_rXGUd5gs0fVsCy54esrfhEzbR13cFq5eUCE9we0MV1EFN345KSodK
 bnzCJusG621lwBEExmbXh_eLGQ0atLB91XDS_YlxSsBD0pbUxsXYWM_2b5Xz
 Fvw_bCEyICVQy8Z4RX.FXCBvojAlSyQqBgJfIkKWFzYnsoObftkwlAMunDHW
 pMrYj.zTxgd_7qH.DzpUo4A--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 8 Sep 2011 13:37:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH] slub Discard slab page only when node partials > minimum
 setting
In-Reply-To: <1315442639.31737.224.camel@debian>
Message-ID: <alpine.DEB.2.00.1109081336320.14787@router.home>
References: <1315188460.31737.5.camel@debian>  <alpine.DEB.2.00.1109061914440.18646@router.home>  <1315357399.31737.49.camel@debian>  <alpine.DEB.2.00.1109062022100.20474@router.home>  <4E671E5C.7010405@cs.helsinki.fi> 
 <6E3BC7F7C9A4BF4286DD4C043110F30B5D00DA333C@shsmsx502.ccr.corp.intel.com>  <alpine.DEB.2.00.1109071003240.9406@router.home> <1315442639.31737.224.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Sep 2011, Alex,Shi wrote:

> BTW, some testing results for your PCP SLUB:
>
> for hackbench process testing:
> on WSM-EP, inc ~60%, NHM-EP inc ~25%
> on NHM-EX, inc ~200%, core2-EP, inc ~250%.
> on Tigerton-EX, inc 1900%, :)

There is no minus on tigerton. I hope that is not a regression?
>
> for hackbench thread testing:
> on WSM-EP, no clear inc, NHM-EP no clear inc
> on NHM-EX, inc 10%, core2-EP, inc ~20%.
> on Tigertion-EX, inc 100%,

> for  netperf loopback testing, no clear performance change.

Hmmm... The sizes of the per cpu partial objects could be varied a bit to
see if more would make an impact.

