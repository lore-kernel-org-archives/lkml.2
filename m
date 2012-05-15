Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab2EOAbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:31:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65027 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932652Ab2EOAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:31:31 -0400
Date: Mon, 14 May 2012 17:31:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
cc: a.p.zijlstra@chello.nl, mingo@kernel.org, pjt@google.com,
        paul@paulmenage.org, akpm@linux-foundation.org, rjw@sisk.pl,
        nacc@us.ibm.com, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com, tj@kernel.org, mschmidt@redhat.com,
        berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 3/5] cpusets: Update tasks' cpus_allowed mask upon
 updates to root cpuset
In-Reply-To: <20120513231609.3566.23600.stgit@srivatsabhat>
Message-ID: <alpine.DEB.2.00.1205141731180.25235@chino.kir.corp.google.com>
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231609.3566.23600.stgit@srivatsabhat>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Srivatsa S. Bhat wrote:

> The root cpuset's cpus_allowed mask can get updated during CPU hotplug.
> However, during those updates, the tasks belonging to the root cpuset
> aren't touched at all - their cpus_allowed masks aren't updated to reflect
> the change in the configuration of the cpuset they belong to.
> 
> Fix this by moving the update of top_cpuset.cpus_allowed to
> scan_cpusets_upon_hotplug() and ensure that the call to update_tasks_cpumask()
> is not missed out for the root cpuset, including for cpu online events.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
