Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758977Ab1FVVgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 17:36:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60154 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab1FVVgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 17:36:24 -0400
Subject: Re: [patch 12/16] sched: prevent interactions with throttled
 entities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110621071700.879990875@google.com>
References: <20110621071649.862846205@google.com>
	 <20110621071700.879990875@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 22 Jun 2011 23:34:19 +0200
Message-ID: <1308778459.1022.63.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 00:17 -0700, Paul Turner wrote:
> +       udd.cpu = rq->cpu;
> +       udd.now = rq->clock_task;
> +       walk_tg_tree_from(cfs_rq->tg, tg_unthrottle_down, tg_nop,
> +                         (void *)&udd); 

How about passing rq along and not using udd? :-)
