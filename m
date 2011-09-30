Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab1I3IJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 04:09:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51906 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab1I3IJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 04:09:18 -0400
Date: Fri, 30 Sep 2011 01:09:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Ripduman Sohan <Ripduman.Sohan@cl.cam.ac.uk>, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH] workqueue: Restore cpus_allowed mask for sleeping
 workqueue rescue threads
Message-ID: <20110930080914.GM10425@mtj.dyndns.org>
References: <1314884193-20454-1-git-send-email-ripduman.sohan@cl.cam.ac.uk>
 <20110902002917.GD2752@htj.dyndns.org>
 <20110915161430.GE1548@tusker>
 <CAOtvUMf0Dx04Piw8bx2oD+F9ttiBP_xCpin7fTvoQqs_dn=ZRQ@mail.gmail.com>
 <20110924030718.GA29319@htj.dyndns.org>
 <CAOtvUMeGddgQK==K09uCVHOn8gbW2PaUaCiWhhOCNx8pvy8QiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOtvUMeGddgQK==K09uCVHOn8gbW2PaUaCiWhhOCNx8pvy8QiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 25, 2011 at 09:02:25AM +0300, Gilad Ben-Yossef wrote:
> Thank you for taking the time to answer my query :-)
> 
> I agree there is no real problem with having an additional task
> bound to an "isolated" CPU so long that it does not run and of
> course that if a task on an isolated CPU initiated activity that
> resulted in requiring the services of a rescuer workqueue thread it
> most certainly needs to run there and that is fine.
> 
> I guess my question is - apart form running on the isolated CPU,
> does the fact that the rescuer thread is bound there can cause
> activity on that CPU originating from a foreign CPU, such as for
> example running an IPI handler in order to migrate it there?

Hmmm... indeed.  This can cause an unnecessary wakeup / migration on
an isolated CPU when another CPU asks for the rescuer, so yeah it
makes sense to change the behavior.  BTW, why didn't the original
patch simply use set_cpus_allowed_ptr(cpu_all_mask)?

Thanks.

-- 
tejun
