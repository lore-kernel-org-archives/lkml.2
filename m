Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab1BIDh1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 22:37:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:35253 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756205Ab1BIDh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 22:37:26 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1905F1Irg506MsOmFSrNFZ/DNqPHMGMaenZ/V+CGa
	fXv4xyMti3HMsQ
Subject: Re: [PATCH 3/3] sched: newidle balance set idle_timestamp only on
 successful pull
From: Mike Galbraith <efault@gmx.de>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Nick Piggin <npiggin@gmail.com>
In-Reply-To: <1297188819-19999-4-git-send-email-venki@google.com>
References: <AANLkTikmWfLv3iMNUky7TRvQtUknLckftiQ4-Br614Rm@mail.gmail.com>
	 <1297188819-19999-4-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 04:37:21 +0100
Message-ID: <1297222641.8035.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 10:13 -0800, Venkatesh Pallipadi wrote:
> load_balance() could return a negative value in the case of
> SMT sibling CPU being busy. Code in idle_balance() though, uses this
> return value as an indicator of successful task pull, ignoring the
> -1 return value.

Yup, garden variety bug.

> This has two problems:
> 1) Resets idle_stamp even when this return value is -1.
> Specific case is on SMT capable system, CPU A is idle and its sibling
> CPU B is busy. In this case, CPU A avg_idle will not depend on
> a task sleeping/waking up on it. Instead it will continue to hold stale
> avg_idle value for extended period of time.

Not good.

Acked-by: Mike Galbraith <efault@gmx.de>

	-Mike

