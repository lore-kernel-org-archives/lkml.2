Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1LIV1c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 16:27:32 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:63331 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1LIV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 16:27:31 -0500
Message-id: <4EE27D28.4040909@verizon.net>
Date: Fri, 09 Dec 2011 16:27:04 -0500
From: "David H. Durgee" <dhdurgee@verizon.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0.1) Gecko/20111122
 Firefox/8.0.1 SeaMonkey/2.5
MIME-version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Request for assistance - excessive kworker CPU wakeups
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
lead to a post by Tejun, indicating the need to trace such issues. 
Running the trace showed that 1933 of 2748 events were of the form:

<idle>-0     [000] 22005.355346: workqueue_queue_work: work 
struct=ffff8800bb411188 function=do_dbs_timer workqueue=ffff88012b5d2c00 
req_cpu=0 cpu=0

Tejun indicated that this is a workitem used by cpufreq and likely 
caused by something else hitting the CPU frequently.  So how do I 
diagnose this further and isolate the cause for correction?

If you would like a summary of this, download this spreadsheet:

http://home.comcast.net/%7Eddurgee/Tracelog.ods

If you would like to inspect the trace log itself:

http://home.comcast.net/%7Eddurgee/tracelog.zip

Dave
