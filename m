Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab2GDPl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 11:41:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58869 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551Ab2GDPlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:41:25 -0400
Subject: Re: [PATCH 14/16] sched: make __update_entity_runnable_avg() fast
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <20120628022415.30496.53532.stgit@kitami.mtv.corp.google.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022415.30496.53532.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jul 2012 17:41:03 +0200
Message-ID: <1341416463.19870.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 19:24 -0700, Paul Turner wrote:
> +#define LOAD_AVG_MAX 46742 /* maximum possible load avg */

With 1024 * 1/(1-y), with y^32 = 0.5 I get 47788.. sup?

