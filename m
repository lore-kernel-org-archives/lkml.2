Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965220Ab2CFPcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:32:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:44149 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965153Ab2CFPcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:32:46 -0500
Message-ID: <1331047932.11248.315.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org
Date: Tue, 06 Mar 2012 16:32:12 +0100
In-Reply-To: <CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331034734.11248.287.camel@twins>
	 <CACvQF52-kZze+SptSCJtsaj=d6b3vg=VgU+Wbqyz-ebYynnUwA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 22:44 +0800, Lai Jiangshan wrote:
> it is srcu_barrier(), it have to wait all callbacks complete for all
> cpus since it is per-cpu
> implementation.
> 
If you enqueue each callback as a work, flush_workqueue() alone should
do that. It'll wait for completion of all currently enqueued works but
ignores new works.


