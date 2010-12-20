Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932756Ab0LTQQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:16:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:58613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932725Ab0LTQQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:16:46 -0500
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <20101220155737.GA1742@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
	 <1292859744.5021.4.camel@laptop>  <20101220155737.GA1742@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 17:16:39 +0100
Message-ID: <1292861799.5021.27.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:57 +0100, Frederic Weisbecker wrote:

> Should I?

Well yes, this interface of explicitly marking a task and cpu as
task_no_hz is kinda restrictive and useless.

When I run 4 cpu-bound tasks on a quad-core I shouldn't have to do
anything to benefit from this.

I don't see why having this cpumask is restricting you in any way,
user-space tasks don't migrate around, that all happens in kernel space.

Also, I'm not quite happy with the pure userspace restriction, but at
least I see why you did that event though you didn't mention that.
