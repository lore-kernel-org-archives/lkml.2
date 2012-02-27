Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2B0XB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:01:26 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:31521 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754006Ab2B0XBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:01:25 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: BJa3gF8VM1m2kTUe.23VZKuxoEXJ7k6J7s2M9.B0EWXfD4K
 KnqYIP57NJaKvZ8CV7iV0yx0xrQdRpnIj2Dm2FbieaVdBCKLeq9uMcJfX5mr
 CIB2jP_gS_n2VFYF1.K_XmIrA8Y832yhDPScFPr.HdvcisaqHgOHWEBLV9Qs
 sHvMscn807TIU_nxFQyqdVBRfa7Z8jzvDb6cvp9LeVQxjtkvli75OgqTztJ.
 inLUYpVOwMNQ7VpheRwwX1L2VQtYAaF33qYgRoIqvpEtKIEcNV3PjzubsImG
 OpIwjj2tvMWHXO_fDc5WajnRF59B.unMQ2kmfjahjvHSRGQGNoCql54AgP85
 Bee_L83IfkM5tq3_19Z3ZcLouAXT_wkzmaubYzfYyywwsqht6od.H9PXhuBu
 RAMH2oZYtMcXslDQKlZx08N94PVbJPCRl3UhP
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 27 Feb 2012 16:39:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH] fix move/migrate_pages() race on task struct
In-Reply-To: <87d390janv.fsf@xmission.com>
Message-ID: <alpine.DEB.2.00.1202271636230.6435@router.home>
References: <20120223180740.C4EC4156@kernel> <alpine.DEB.2.00.1202231240590.9878@router.home> <4F468F09.5050200@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231334290.10914@router.home> <4F469BC7.50705@linux.vnet.ibm.com> <alpine.DEB.2.00.1202231536240.13554@router.home>
 <m1ehtkapn9.fsf@fess.ebiederm.org> <alpine.DEB.2.00.1202240859340.2621@router.home> <4F47BF56.6010602@linux.vnet.ibm.com> <alpine.DEB.2.00.1202241053220.3726@router.home> <alpine.DEB.2.00.1202241105280.3726@router.home> <4F47C800.4090903@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1202241131400.3726@router.home> <87sjhzun47.fsf@xmission.com> <alpine.DEB.2.00.1202271238450.32410@router.home> <87d390janv.fsf@xmission.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012, Eric W. Biederman wrote:

> The problem that I see is that we may race with a suid exec in which
> case the permissions checks might pass for the pre-exec state and then
> we get the post exec mm that we don't actually have permissions for,
> but we manipulate it anyway.

So what? Page migration does not change the behavior of the code. It only
changes the latencies seen. The hacker can mess up the code so that the
suid exec runs slower?

> So we really need to do something silly like get task and
> task->self_exec_id.  Then perform the permission checks and get the mm.
> Then if just before we perform the operation task->self_exec_id is
> different restart the system call, or fail with something like -EAGAIN.

I am still not convinced as to why we would do this.
