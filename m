Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2AYB1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:27:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957Ab2AYB1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:27:34 -0500
Date: Tue, 24 Jan 2012 17:27:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
Message-Id: <20120124172732.19b3d9f4.akpm@linux-foundation.org>
In-Reply-To: <1327450945.14373.24.camel@edumazet-laptop>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1327449683.14373.12.camel@edumazet-laptop>
	<20120124161221.032325d1.akpm@linux-foundation.org>
	<1327450945.14373.24.camel@edumazet-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012 01:22:25 +0100
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le mardi 24 janvier 2012 __ 16:12 -0800, Andrew Morton a __crit :
> 
> > Did you measure the improvement from this patch?
> 
> Unfortunately I can not reboot the server where I noticed this
> performance problem.
> 
> On the smaller one, performance improvement is about 20%, because the
> second run of show_stat() can use data present in cpu cache.
> 
> On big machines, I guess the 128 bytes per possible cpu reservation can
> avoid the second run. (since a typical cpuXXX line is smaller than 128
> bytes)

I had a fiddle on an 8-way x86_64 machine.  I'm unable to demonstrate
any improvement for either of

time (for i in $(seq 1000); do; cat /proc/self/stat > /dev/null; done)
time (for i in $(seq 1000); do; cat /proc/1/stat > /dev/null; done)

oh well.
