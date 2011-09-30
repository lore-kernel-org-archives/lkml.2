Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1I3Iy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:54:26 -0400
Received: from mta0.cl.cam.ac.uk ([128.232.25.20]:35827 "EHLO
	mta0.cl.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1I3IyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:54:25 -0400
Date: Fri, 30 Sep 2011 09:54:21 +0100
From: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
Message-ID: <20110930085421.GA11756@tusker>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
 <20110902002917.GD2752@htj.dyndns.org>
 <20110915161430.GE1548@tusker>
 <CAOtvUMf0Dx04Piw8bx2oD+F9ttiBP_xCpin7fTvoQqs_dn=ZRQ@mail.gmail.com>
 <20110924030718.GA29319@htj.dyndns.org>
 <CAOtvUMeGddgQK==K09uCVHOn8gbW2PaUaCiWhhOCNx8pvy8QiQ@mail.gmail.com>
 <20110930080914.GM10425@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930080914.GM10425@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> Hmmm... indeed.  This can cause an unnecessary wakeup / migration on
> an isolated CPU when another CPU asks for the rescuer, so yeah it
> makes sense to change the behavior.  BTW, why didn't the original
> patch simply use set_cpus_allowed_ptr(cpu_all_mask)?
> 

Because while at present all (bound) rescuer threads have an associated workqueue on each CPU, I didn't want to assume this arrangement would _always_ be the case.  It was my thinking that for bound threads, iterating over the CPUs to only set those that have an associated workqueue for the rescuer would insulate agsinst any future case where rescuer threads may be bound to a subset of CPUs.

Kind regards,

--rip

