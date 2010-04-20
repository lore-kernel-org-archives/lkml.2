Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0DTJ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 05:26:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822Ab0DTJ0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 05:26:42 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO
Date: Tue, 20 Apr 2010 11:29:02 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, tglx@linutronix.de, davej@redhat.com,
       cpufreq@vger.kernel.org
References: <20100418115949.7b743898@infradead.org> <20100418120346.1b478410@infradead.org>
In-Reply-To: <20100418120346.1b478410@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004201129.02370.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 April 2010 21:03:46 Arjan van de Ven wrote:
> From 27966bedabea83c4f3ae77507eceb746b1f6ebae Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 18 Apr 2010 11:15:56 -0700
> Subject: [PATCH 7/7] ondemand: Solve the big performance issue with ondemand during disk IO

 
> This algorithm falls flat on its face in the light of workloads where
> you're alternatingly disk and CPU bound, such as the ever popular
> "git grep", but also things like startup of programs and maildir using
> email clients... much to the chagarin of Andrew Morton.
Have you looked at:
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency
and
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate
Transition latency comes from ACPI tables and sampling rate depends
on it.
Reducing the sampling rate, significantly reduces performance loss.
There were bugs in this area, on latest kernels with latest (MSR switching)
HW you should see:
cat /sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate
10000

    Thomas
