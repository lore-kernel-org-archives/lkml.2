Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1BYRyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 12:54:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab1BYRyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 12:54:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=kPl6dWjEqxgeLDmDu8WRs/IkJcjdKOTdAjtXONPnLONOJIlTGn6eKDvlyrtFTRR/Bo
         lsW/Ti95MjXK33IKOahg==
MIME-Version: 1.0
In-Reply-To: <20110224154525.1b463723@jacob-laptop>
References: <1297807750-28844-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1297807750-28844-2-git-send-email-jacob.jun.pan@linux.intel.com>
 <201102160100.15487.rjw@sisk.pl> <20110215163812.7fa020b5@putvin>
 <20110216032321.GA14893@count0.beaverton.ibm.com> <20110224154525.1b463723@jacob-laptop>
From: Paul Menage <menage@google.com>
Date: Fri, 25 Feb 2011 09:53:59 -0800
Message-ID: <AANLkTinyhp29X8-atA=0DaHFuthTjVMJgBOitP52gwEX@mail.gmail.com>
Subject: Re: [PATCH 1/1, v9] cgroup/freezer: add per freezer duty ratio control
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Arjan van de Ven <arjan@linux.intel.com>,
        container cgroup <containers@lists.linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, akpm@linux-foundation.org,
        rdunlap@xenotime.net, Cedric Le Goater <clg@vnet.ibm.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 3:45 PM, jacob pan
<jacob.jun.pan@linux.intel.com> wrote:
> I played with v3 and v4 of the CFS bandwidth patch. When the cpu
> cgroup exceeds its cfs_quota, it does have the same effect as this
> patch in terms of freeze/thaw at given period and allowed runtime. But
> when the cgroup cpu usage is below cfs_quota, it is not throttled.
> Therefore, it cannot reduce wakeups.

How about a userspace daemon that periodically flips the CPU quota for
the cgroup between zero and the group's runnable level? Wouldn't that
achieve what you need pretty easily without having to introduce
additional complexity and threads into the kernel?

Paul
