Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab2EGP1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:27:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58844 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab2EGP1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:27:18 -0400
Message-ID: <4FA7E996.9010302@gmail.com>
Date: Mon, 07 May 2012 23:26:14 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org, stern@rowland.harvard.edu
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
References: <20120504191535.4603.83236.stgit@srivatsabhat> <1336159496.6509.51.camel@twins> <4FA434E9.6000305@linux.vnet.ibm.com> <1336162456.6509.63.camel@twins> <20120504204627.GB18177@linux.vnet.ibm.com> <4FA56047.9090405@linux.vnet.ibm.com>
In-Reply-To: <4FA56047.9090405@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2012 01:15 AM, Srivatsa S. Bhat wrote:
>> I, personally, think we should just kill of tasks in cpuset-constrained
>> environments that are nonsensical (no memory, no cpus, etc.). 
> 
> 
> Even I think just killing the tasks or maybe even preventing such destructive
> hotplug (last cpu in a cpuset going offline) would have been way more
> easier to handle and also logical.. and userspace would have been more
> cautious while dealing with cpusets, from the beginning....
On one another OS, there's a "force" flag for cpu_down(). If cpu_down() is
called with the "force" flag as false, the request will be rejected if 
any cpuset becomes empty; otherwise it will try to assign other CPUs to
the empty cpusets.

So the administrator could choose different behaviors.

