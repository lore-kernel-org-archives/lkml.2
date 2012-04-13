Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab2DMS65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:58:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42505 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979Ab2DMS6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:58:55 -0400
Date: Fri, 13 Apr 2012 21:58:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Matt Renzelmann <mjr@cs.wisc.edu>
Subject: Re: [RFC] workqueue: do a sanity check on new work
Message-ID: <20120413185838.GC25091@elgon.mountain>
References: <20120413143524.GA3668@elgon.mountain>
 <CAOS58YOSy-acB7Oara9ay1Zeznx0vCSB0Z23F+6KtEKZ56nXmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOS58YOSy-acB7Oara9ay1Zeznx0vCSB0Z23F+6KtEKZ56nXmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090207.4F887766.001A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 09:39:13AM -0700, Tejun Heo wrote:
> Hello, Dan.
> 
> On Fri, Apr 13, 2012 at 7:35 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > There may be a better way to do this.  If someone tries to call
> > shedule_work() on a work_struck before doing an INIT_WORK() then we
> > hit the BUG_ON(!list_empty(&work->entry)) in __queue_work() and hang.
> > Instead of that, we could just print a stack dump and return.
> 
> Hmmm... why not just change the BUG_ON() in __queue_work() to "if
> (WARN_ON()) return;"?
> 

Good point.  I'll do that.

regards,
dan carpenter
