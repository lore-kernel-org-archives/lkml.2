Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab0DOPGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 11:06:16 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:35409 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab0DOPGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 11:06:15 -0400
X-Spam-Processed: digidescorp.com, Thu, 15 Apr 2010 10:06:12 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=172187e3a9=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: sched_clock - microblaze
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: michal.simek@petalogix.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Wu Zhangjin <wuzhangjin@gmail.com>
In-Reply-To: <4BC728DD.5020404@petalogix.com>
References: <4BC728DD.5020404@petalogix.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Thu, 15 Apr 2010 10:06:10 -0500
Message-Id: <1271343970.3856.7.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal,

On Thu, 2010-04-15 at 16:55 +0200, Michal Simek wrote:

> Is unimplemented sched_clock the reason why ftrace not show fine grain time?
> 
> Or is there any other thing which is wrong?
> 

I think that's it. On my platform we have a free-running 1 MHz counter
so I implemented a platform sched_clock for that, and I get nice ftrace
times.

 0) + 65.000 us   |  finish_task_switch();
 0)               |  lock_sock_nested() {
 0) + 52.000 us   |    local_bh_disable();
 0) + 53.000 us   |    local_bh_enable();
 0) ! 264.000 us  |  }

Steve



