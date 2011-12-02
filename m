Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab1LBUi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:38:58 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:36702 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab1LBUi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:38:57 -0500
Message-id: <4ED93750.7080801@verizon.net>
Date: Fri, 02 Dec 2011 15:38:40 -0500
From: "David H. Durgee" <dhdurgee@verizon.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0.1) Gecko/20111122
 Firefox/8.0.1 SeaMonkey/2.5
MIME-version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: excessive kworker CPU wakeups
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently purchased a Lenovo IdeaPad Z560, model 09143YU, and as I am 
not a Windows fan I installed Linux Mint 11 Katya x64 to use instead of 
the supplied W7.  I was encountering a known hang and had to upgrade to 
a later kernel, so I am now using the 2.6.38-11-generic #50-Ubuntu SMP 
Mon Sep 12 21:17:25 UTC 2011 x86_64 kernel.

I had my first occasion to use the laptop for an extended period for the 
first time over the Thanksgiving holiday and I found it needed to be 
tuned.  I downloaded powertop and used it to discover where my problems 
were.  After addressing excessive i915 interrupts due to DRI the next 
most frequent cause of CPU wakeups is a kworker on the system.  A search 
lead to a post by Tejun, who is cc'd, indicating the need to trace such 
issues.  Running the trace showed that 1933 of 2748 events were of the form:

<idle>-0     [000] 22005.355346: workqueue_queue_work: work 
struct=ffff8800bb411188 function=do_dbs_timer workqueue=ffff88012b5d2c00 
req_cpu=0 cpu=0

Tejun indicated that this is a workitem used by cpufreq and likely 
caused by something else hitting the CPU frequently.  So how do I 
diagnose this further and isolate the cause for correction?

Dave
