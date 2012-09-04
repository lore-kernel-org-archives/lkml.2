Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab2IDQko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:40:44 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab2IDQkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:40:42 -0400
Date: Tue, 4 Sep 2012 09:36:09 -0700
From: Silas Boyd-Wickizer <sbw@mit.edu>
To: Rusty Russell <rusty@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/4 V2] Use get_online_cpus to avoid races involving CPU
 hotplug
Message-ID: <20120904163608.GB14382@mit.edu>
References: <20120803193223.GA4227@mit.edu>
 <87k3whsalw.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3whsalw.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

I used libsparse and kernel source annotations to check that code uses
for_each_online_cpu in contexts with hotplug disabled
(e.g. get_online_cpus(), preempt_disable, ..).  I compiled with an x86
64-bit allyesconfig, so I missed other architecture specific usages.
The checker code isn't great and the results still require some manual
inspection for weeding out false positives, etc:

  http://pdos.csail.mit.edu/~sbw/online-checker/

Silas

On Thu, Aug 30, 2012 at 06:02:11AM +0930, Rusty Russell wrote:
> Silas Boyd-Wickizer <sbw@mit.edu> writes:
> 
> > Hello,
> >
> > This is the second version of the patches to fix races described in:
> >
> >   https://groups.google.com/forum/?fromgroups#!topic/linux.kernel/iSUDr94Qehc
> >
> > The changes in this version are:
> >
> >   * fix commit log typo;
> >   * prevent a race in via_cputemp_exit;
> >   * and a new patch that prevents races during init/exit in
> >     drivers/hwmon/coretemp.c.
> 
> Hi Silas,
> 
>         Good work! How did you find these?
> 
> Cheers,
> Rusty.
> 
