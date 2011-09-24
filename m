Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab1IXDHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 23:07:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56515 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab1IXDHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 23:07:24 -0400
Date: Sat, 24 Sep 2011 12:07:18 +0900
From: Tejun Heo <tj@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
Message-ID: <20110924030718.GA29319@htj.dyndns.org>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
 <20110902002917.GD2752@htj.dyndns.org>
 <20110915161430.GE1548@tusker>
 <CAOtvUMf0Dx04Piw8bx2oD+F9ttiBP_xCpin7fTvoQqs_dn=ZRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMf0Dx04Piw8bx2oD+F9ttiBP_xCpin7fTvoQqs_dn=ZRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 18, 2011 at 09:36:57AM +0300, Gilad Ben-Yossef wrote:
> There is at least one use case where I think this can be a problem -
> cpu isolation.
> 
> If you decide to partition your CPU to give some group of processes a
> set of CPUs all to their own (using cgroups/cpuset for example) having
> non related bound processes really gets in the way. You would really
> want to migrate away non related tasks from the isolated cpuset and
> having a bound kernel thread prevents that.

Hmm... I don't think this has much to do with CPU isolation.
Workqueue rescuers are reactively invoked to resolve possible resource
deadlock.  It doesn't initiate operations on itself while CPU
isolation requires moving all sources of unwanted activites off the
isolated CPUs.  Having idle rescuers not bound to any CPU might look
prettier but wouldn't help anything - it's not an activity source and
the 'wanted' activities on the isolated CPU also require rescuers for
forward progress guarantee.

Thanks.

-- 
tejun
