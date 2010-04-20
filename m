Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0DTLF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 07:05:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:52392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab0DTLF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 07:05:27 -0400
Date: Tue, 20 Apr 2010 04:07:08 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with
 ondemand during disk IO
Message-ID: <20100420040708.1ae390b1@infradead.org>
In-Reply-To: <201004201129.02370.trenn@suse.de>
References: <20100418115949.7b743898@infradead.org>
	<20100418120346.1b478410@infradead.org>
	<201004201129.02370.trenn@suse.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 11:29:02 +0200
Thomas Renninger <trenn@suse.de> wrote:

> Have you looked at:
> /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency
> and
> /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate
> Transition latency comes from ACPI tables and sampling rate depends
> on it.

of course I have; in practice on systems i use it is always a 10
milliseconds interval, which is the minimum it gets.
Yes this was a bug, no it wasn't the bug here ;-)

> Reducing the sampling rate, significantly reduces performance loss

while it does, it is not nearly sufficient for the alternating IO/CPU
cases I've looked at. I've looked at many timecharts for various IO/CPU
workloads, including my normal own use as well as Andrews and the CPU
busy periods are in the 1 - 20 msec range between IOs most of the time,
for which a 10 msec sampling is obviously problematic. 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
