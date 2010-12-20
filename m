Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab0LTQCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:02:50 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36980 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757900Ab0LTQCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:02:49 -0500
Subject: Re: [RFC PATCH 07/15] nohz_task: Restart tick when RCU forces nohz
 task cpu quiescent state
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292858662-5650-8-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-8-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 17:02:09 +0100
Message-ID: <1292860929.5021.16.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> If a cpu is in nohz mode due to a nohz task running, then
> it is not able to notify quiescent states requested by other
> CPUs.
> 
> Then restart the tick to remotely force the quiescent states on the
> nohz task cpus.

-ENOPARSE.. if its in NOHZ state, it couldn't possibly need to
participate in the quiescent state machine because the cpu is in a
quiescent state and has 0 RCU activity.

