Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030822Ab2CNOJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:09:45 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:20563 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030673Ab2CNOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:09:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: x5kIafYVM1kF3qlv020uZriy.mIb21eDRTQGO5nYCnZGeiQ
 _TdkyD8gWKzz3Cbx9GG4IcI_FArmp3rCh_NOAhpwCATTpP_xZvoM_6abdkh6
 gr3ZC3jF4R2MkPFKNpbk5RBBYzXeLGZQhAKMiE2jua_Mf8xUaPk2kLntdLUO
 t5I20xL9MXQdWLCvG.vCUE_CQajdZHPLaLPceWTSMC5Rm5OBUuOjgreDzYQU
 kEwANQ6OkM8v0c1Pao6wHR2e0BRLNYTU.WXXenzTyqP_6WHfqAOm9eQyHZsC
 QVsgi7SaUABgh_bQffURJROWQPjT1MzqrRu5SQd0laxWxZCtXLNTl.ZkowOD
 ThNIGeRu4cUYJP23bqmY.nkYiH68s2fFqk.eoZfkN..y_Ji5dN_pZzuRbBaW
 B
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 14 Mar 2012 09:09:39 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: fix vmstat_update to keep scheduling itself on all
 cores
In-Reply-To: <CAOtvUMdVrjUHLx2jZ2xbpBoDBMCX8sdCASEkmXCtBrU-gQ3EhQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1203140908010.5485@router.home>
References: <CAOtvUMdVrjUHLx2jZ2xbpBoDBMCX8sdCASEkmXCtBrU-gQ3EhQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Gilad Ben-Yossef wrote:

> We set up per-cpu work structures for vmstat and schedule them on
> each cpu when they go online only to re-schedule them on the general
> work queue when they first run.

schedule_delayed_work queues on the current cpu unless the
WQ_UNBOUND flag is set. Which is not set for vmstat_work.

