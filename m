Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030414Ab2CFLfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:35:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40644 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965161Ab2CFLfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:35:42 -0500
Message-ID: <1331033715.11248.281.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Tue, 06 Mar 2012 12:35:15 +0100
In-Reply-To: <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 17:57 +0800, Lai Jiangshan wrote:
> +/* Must called with sp->flip_check_mutex and sp->gp_lock held; */
> +static bool check_zero_idx(struct srcu_struct *sp, int idx,
> +               struct srcu_head *head, int trycount)
> +{
> +       unsigned long chck_seq;
> +       bool checked_zero;
> + 

	lockdep_assert_held(&sp->flip_check_mutex);
	lockdep_assert_held(&sp->gp_lock);

and you can do away with your comment (also you forgot a verb).
