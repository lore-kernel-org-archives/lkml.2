Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab0DVUg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:36:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757906Ab0DVUgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:36:15 -0400
Date: Thu, 22 Apr 2010 13:35:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Rik van Riel <riel@redhat.com>, John Stoffel <john@stoffel.org>,
       Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
Message-Id: <20100422133505.6e7a24ad.akpm@linux-foundation.org>
In-Reply-To: <20100422170801.GZ5677@sgi.com>
References: <20100421165934.GN16427@zorg.emea.sgi.com>
	<4BCF336B.1050706@redhat.com>
	<19407.20109.308816.104856@stoffel.org>
	<20100421193350.GU16427@zorg.emea.sgi.com>
	<19407.23456.469074.256306@stoffel.org>
	<20100421222414.GA26241@suse.de>
	<4BCF80F2.2010906@redhat.com>
	<20100421232200.GA22877@suse.de>
	<20100422102852.72837494@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1004220743080.9086@i5.linux-foundation.org>
	<20100422170801.GZ5677@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 12:08:02 -0500
Robin Holt <holt@sgi.com> wrote:

> > Which I'm not entirely sure makes the case for the kernel parameter much 
> > stronger, though. I wonder if it's not more appropriate to just have a 
> > total hack saying
> > 
> > 	if (max_pids < N * max_cpus) {
> > 		printk("We have %d CPUs, increasing max_pids to %d\n");
> > 		max_pids = N*max_cpus;
> > 	}
> > 
> > where "N" is just some random fudge-factor. It's reasonable to expect a 
> > certain minimum number of processes per CPU, after all.
> 
> How about:
> 
> 	pid_max_min = max(pid_max_min, 19 * num_possible_cpus());
> 	pid_max_baseline = 2048 * num_possible_cpus();
> 
> 	if (pid_max < pid_max_baseline) {
> 		printk("We have %d CPUs, increasing pid_max to %d\n"...
> 		pid_max = pid_max_baseline;
> 	}
> 
> 
> This would scale pid_max_min by a sane amount, leave the default value
> of pid_max_min and pid_max untouched below 16 cpus and then scale both
> up linearly beyond that.

Something like that would work.  We shouild ensure that pid_max cannot
end up being less than the current PID_MAX_DEFAULT.

