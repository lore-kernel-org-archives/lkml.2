Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab2DWVp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:45:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:33595 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2DWVp4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:45:56 -0400
Message-ID: <1335217531.28150.179.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Date: Mon, 23 Apr 2012 23:45:31 +0200
In-Reply-To: <4F95C8AF.2040606@sssup.it>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	 <1335177104.28150.113.camel@twins> <4F9530F7.9010400@gmail.com>
	 <4F95C8AF.2040606@sssup.it>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 22:25 +0100, Tommaso Cucinotta wrote:
> I cannot get the real difference between rq->clock and rq->task_clock. 

One runs at wall-time (rq->clock) the other excludes time in irq-context
and steal-time (rq->clock_task).

The idea is that ->clock_task gives the time as observed by schedulable
tasks and excludes other muck.
