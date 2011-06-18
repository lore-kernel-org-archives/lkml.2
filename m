Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab1FRXiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 19:38:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FRXiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 19:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=IQmq/d7ctGiZd3WidOf6rITu0+haZpgnHBeadLdCMu0YTVn4vyDd9SgABsN0+ztBEx
         UML4ltV8lnt42X9PhN6w==
Date: Sat, 18 Jun 2011 16:34:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Ravikiran Thirumalai <kiran@scalex86.org>,
        William Irwin <wli@holomorphy.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Patch] hugetlb: remove user_shm_lock() check from
 hugetlb_file_setup()
In-Reply-To: <20110618071308.GA24743@cr0>
Message-ID: <alpine.DEB.2.00.1106181630480.3431@chino.kir.corp.google.com>
References: <20110618071308.GA24743@cr0>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="397155492-1232856202-1308440057=:3431"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--397155492-1232856202-1308440057=:3431
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sat, 18 Jun 2011, Américo Wang wrote:

> 
> This is a revert of
> 
> commit 2584e517320bd48dc8d20e38a2621a2dbe58fade
> Author: Ravikiran G Thirumalai <kiran@scalex86.org>
> Date:   Tue Mar 31 15:21:26 2009 -0700
> 
>     mm: reintroduce and deprecate rlimit based access for SHM_HUGETLB
> 
> 
> because it is deprecated and scheduled to be removed.
> 

I know this is scheduled for removal and it is quite past due, but I think 
we need to do some due diligence before just yanking the whole thing out.  
A printk_once() about some mysterious application using SHM_HUGETLB 
doesn't seem very helpful in migrating users to start using 
/proc/sys/vm/hugetlb_shm_group, and suddenly returning -EPERM when 
attempting it doesn't seem very responsible, despite what 
Documentation/feature-removal-schedule.txt may say.

For context, we just ran into this internally where this warning at one 
point appeared to be WARN_ON_ONCE().  That seems more attention grabbing 
because it at least allows users to start understanding what the issue is 
and who needs to be fixed.
--397155492-1232856202-1308440057=:3431--
