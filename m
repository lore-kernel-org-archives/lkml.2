Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab0DVSMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 14:12:24 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:41188 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab0DVSMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 14:12:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19408.37169.630371.794587@stoffel.org>
Date: Thu, 22 Apr 2010 14:10:57 -0400
From: "John Stoffel" <john@stoffel.org>
To: Robin Holt <holt@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Rik van Riel <riel@redhat.com>, John Stoffel <john@stoffel.org>,
       Hedi Berriche <hedi@sgi.com>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Jack Steiner <steiner@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 1/1] init: Provide a kernel start parameter to increase
 pid_max v2
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
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Robin" == Robin Holt <holt@sgi.com> writes:

>> Which I'm not entirely sure makes the case for the kernel parameter much 
>> stronger, though. I wonder if it's not more appropriate to just have a 
>> total hack saying
>> 
>> if (max_pids < N * max_cpus) {
>> printk("We have %d CPUs, increasing max_pids to %d\n");
>> max_pids = N*max_cpus;
>> }
>> 
>> where "N" is just some random fudge-factor. It's reasonable to expect a 
>> certain minimum number of processes per CPU, after all.

Robin> How about:

Robin> 	pid_max_min = max(pid_max_min, 19 * num_possible_cpus());
Robin> 	pid_max_baseline = 2048 * num_possible_cpus();

Robin> 	if (pid_max < pid_max_baseline) {
Robin> 		printk("We have %d CPUs, increasing pid_max to %d\n"...
Robin> 		pid_max = pid_max_baseline;
Robin> 	}


Robin> This would scale pid_max_min by a sane amount, leave the default value
Robin> of pid_max_min and pid_max untouched below 16 cpus and then scale both
Robin> up linearly beyond that.

Looks good, but how about some comments and some defines for the magic
numbers of 2048 and 19?  

John

