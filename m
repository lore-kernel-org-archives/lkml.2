Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1CaObI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:31:08 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:43788 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752974Ab1CaObG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:31:06 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: xTk9SToVM1k0s3avqyO7YDSrNgaf_w5KFkoNrQawEUuDPXN
 NBxjAMsFf.velhcIibt8PfJTuAdrdzijAPiJRsj4t_LaCK4Ta57fVbDNYTPz
 2OyAcH1ohv1V6KsqBTFV5IMghtoIsBNki1wxzdAM1Skcbdh5yBgQxD5Ur3fM
 imQhVlfXNChNCOb6OYGQE2iGP1fck.s2lwiSI8nHttfj1ILyHh5XVSd1PnZP
 fLN1uKksqh6zkTMfkMQTdE2u67.XDIQ5v84eedF5WylZvQhOWHMnJS7VeGvi
 QrCVE7kt.17wqAgJzpegEe_pPLszPV.ipMmlh9BsjTqZxNxnw5Z.6jjvtuwk
 hzUGodExvYz_1lOuo
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 31 Mar 2011 09:31:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip:x86/mm] x86-64, NUMA: Remove custom phys_to_nid()
 implementation
In-Reply-To: <20110331135744.GE3385@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103310920340.20823@router.home>
References: <20110331135744.GE3385@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Tejun Heo wrote:

> However, with SPARSE memory model, the nid is encoded in page flags.
> The perfect hash implementation was for DISCONTIG memory model which
> got removed years ago by b263295dbf (x86: 64-bit, make sparsemem
> vmemmap the only memory model).

Most memory models have the nid either in page flags or you can get it
from the zone that a page belongs to. So after boot its easy to
determine the node. However, at early boot the page flags may be
initialized relatively late. early_pfn_to_nid does use the early node map
to determine the node and not the page flags. You are switching to
the generic implementation of __pfn_to_nid and dropping the duplicate arch
logic.

Reviewed-by: Christoph Lameter <cl@linux.com>

