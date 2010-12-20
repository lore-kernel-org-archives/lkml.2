Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0LTQ15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 11:27:57 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43637 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0LTQ14 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 11:27:56 -0500
Subject: Re: [RFC PATCH 12/15] clocksource: Ignore nohz task cpu in
 clocksource watchdog
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
In-Reply-To: <1292858662-5650-13-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
	 <1292858662-5650-13-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 17:27:38 +0100
Message-ID: <1292862458.5021.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> 
> The watchdog should probably make an exception for nohz task cpus
> that want to be interrupted the least possible.
> 
> However we probably need to warn the user about that.
> 
> Another solution would be to make this timer defferable.

Nah, both skipping a cpu and making the timer deferrable render the
watchdog useless, just disable the thing.
