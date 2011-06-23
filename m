Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1FWFhD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:37:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43973 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab1FWFhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:37:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=X/Jimt2hPkt1t/FNF281UCJOZzHkSNMchMVN5JOu/GwVazId9ncAtQwKP01xA3Y/3a
         vxTqevEvmPMlvW/FxwKg==
Date: Wed, 22 Jun 2011 22:32:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Ravikiran Thirumalai <kiran@scalex86.org>,
        William Irwin <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Patch] hugetlb: remove user_shm_lock() check from
 hugetlb_file_setup()
In-Reply-To: <BANLkTi=7O2hW37Mt2NCvxDQq6Ldsa6XhXw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106222230460.2981@chino.kir.corp.google.com>
References: <20110618071308.GA24743@cr0> <alpine.DEB.2.00.1106181630480.3431@chino.kir.corp.google.com> <BANLkTi=7O2hW37Mt2NCvxDQq6Ldsa6XhXw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1010654852-1308807151=:2981"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1010654852-1308807151=:2981
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 23 Jun 2011, Américo Wang wrote:

> > I know this is scheduled for removal and it is quite past due, but I think
> > we need to do some due diligence before just yanking the whole thing out.
> > A printk_once() about some mysterious application using SHM_HUGETLB
> > doesn't seem very helpful in migrating users to start using
> > /proc/sys/vm/hugetlb_shm_group, and suddenly returning -EPERM when
> > attempting it doesn't seem very responsible, despite what
> > Documentation/feature-removal-schedule.txt may say.
> >
> > For context, we just ran into this internally where this warning at one
> > point appeared to be WARN_ON_ONCE().  That seems more attention grabbing
> > because it at least allows users to start understanding what the issue is
> > and who needs to be fixed.
> 
> Well, we put printk_once with KERN_WARNING level, this is already an enough
> warning, the only difference with WARN_ON_ONCE() is this has no backtrace
> which is not important for this case.
> 

NACK.

As explained above, using printk_once() to identify that some unidentified 
application is using SHM_HUGETLB to charge against the mlock rlimit 
through mmap() isn't sufficient notice and _will_ result in userspace 
breakage.  Please convert this to a WARN_ON_ONCE() so the application is 
identified, wait 6-12 months, convert it to a WARN_ON(), wait 6-12 months, 
then remove it.

Thanks.
--397155492-1010654852-1308807151=:2981--
