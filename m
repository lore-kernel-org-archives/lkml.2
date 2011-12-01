Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab1LAWfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:35:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61945 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab1LAWff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:35:35 -0500
Date: Thu, 1 Dec 2011 14:35:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Chinner <david@fromorbit.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [3.2-rc3] OOM killer doesn't kill the obvious memory hog
In-Reply-To: <20111201124634.GY7046@dastard>
Message-ID: <alpine.DEB.2.00.1112011432110.27778@chino.kir.corp.google.com>
References: <20111201093644.GW7046@dastard> <20111201185001.5bf85500.kamezawa.hiroyu@jp.fujitsu.com> <20111201124634.GY7046@dastard>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011, Dave Chinner wrote:

> > /*
> >  * /proc/<pid>/oom_score_adj set to OOM_SCORE_ADJ_MIN disables oom killing for
> >  * pid.
> >  */
> > #define OOM_SCORE_ADJ_MIN       (-1000)
> > 
> >  
> > IIUC, this task cannot be killed by oom-killer because of oom_score_adj settings.
> 
> It's not me or the test suite that setting this, so it's something
> the kernel must be doing automagically.
> 

The kernel does not set oom_score_adj to ever disable oom killing for a 
thread.  The only time the kernel touches oom_score_adj is when setting it 
to "1000" in ksm and swap to actually prefer a memory allocator for oom 
killing.

It's also possible to change this value via the deprecated 
/proc/pid/oom_adj interface until it is removed next year.  Check your 
dmesg for warnings about using the deprecated oom_adj interface or change 
the printk_once() in oom_adjust_write() to a normal printk() to catch it.
