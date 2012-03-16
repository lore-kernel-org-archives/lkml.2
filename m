Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab2CPSfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:35:16 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:21692 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751534Ab2CPSen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:34:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: tuyrBJAVM1lDMVGwnedmPGXIiuKobE2fBEwrRqHsZHQj4v4
 gReWFGd0QS429fB_sbyRrgZ4C000tJGwSg4B1n7qEHPn1GAK2YwKfQaZVhS6
 dk7tlF2gdYTS3hZ.k_RS9wolLY7YJhYsS6fURiDsHKG8c7snuzdzswWn.qho
 rkywrnNGCpnyIcn9Csmru_Oc9I7NntfqcCoDs4IgHZqV7Y8tw_Hm0RM2cU6O
 enhw7U9PQ2nGtwb7gM48HYhJ9frdhg0WguetPT5Y1unIK7CRSrXCewn1HqAF
 t9b_7eD3loCfeRp9YPUfDeozJeDkw6gx2l.WitQhMtErbpz8r8cyKCijHvh1
 8XXZ0Zs0GULnTw1s1Ux4OsNNTAqGhLJqUzUxKYHDPzkLPrKAfqrSldgsUaiS
 H
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 16 Mar 2012 13:34:37 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Dan Smith <danms@us.ibm.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 10/26] mm, mpol: Make mempolicy home-node aware
In-Reply-To: <20120316144240.763518310@chello.nl>
Message-ID: <alpine.DEB.2.00.1203161333370.10211@router.home>
References: <20120316144028.036474157@chello.nl> <20120316144240.763518310@chello.nl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012, Peter Zijlstra wrote:

> Add another layer of fallback policy to make the home node concept
> useful from a memory allocation PoV.
>
> This changes the mpol order to:
>
>  - vma->vm_ops->get_policy	[if applicable]
>  - vma->vm_policy		[if applicable]
>  - task->mempolicy
>  - tsk_home_node() preferred	[NEW]
>  - default_policy
>
> Note that the tsk_home_node() policy has Migrate-on-Fault enabled to
> facilitate efficient on-demand memory migration.

The numa hierachy is already complex. Could we avoid adding another layer
by adding a MPOL_HOME_NODE and make that the default?

