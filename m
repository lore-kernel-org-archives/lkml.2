Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2GKOi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 10:38:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35178 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab2GKOi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 10:38:58 -0400
Message-ID: <1342017499.3462.160.camel@twins>
Subject: Re: [PATCH] trace: add ability to set a target task for events (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Vagin <avagin@openvz.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arun Sharma <asharma@fb.com>
Date: Wed, 11 Jul 2012 16:38:19 +0200
In-Reply-To: <20120711143656.GB17991@somewhere>
References: <1342016098-213063-1-git-send-email-avagin@openvz.org>
	 <20120711143121.GA17991@somewhere> <1342017221.3462.159.camel@twins>
	 <20120711143656.GB17991@somewhere>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 16:36 +0200, Frederic Weisbecker wrote:
> 
> In this case he can just record sched wakeup as well. With sched_switch
> + sched_wakeup, he'll unlikely lose events.
> 
> With sched_stat_sleep he will lose events, unless we fix this period
> demux thing. 

But without this patch, the sched_wakeup will belong to another task, so
if you trace task A, and B wakes you, you'll never see the wakeup.
