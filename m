Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab1CXN5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 09:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1CXN5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 09:57:13 -0400
Date: Thu, 24 Mar 2011 09:56:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH v2 0/8] Provide cgroup isolation for buffered
 writes.
Message-ID: <20110324135657.GC20434@redhat.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com>
 <20110323012755.GA10325@redhat.com>
 <AANLkTi=YyY0dCVP+JAJsyiYYqWMwf1XBROf_h_eG0yEL@mail.gmail.com>
 <20110323200621.GJ13315@redhat.com>
 <AANLkTi=mCAdX1KJrQRoi=mwtW=ZAANWo_Tzc+JNR34rr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=mCAdX1KJrQRoi=mwtW=ZAANWo_Tzc+JNR34rr@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 03:32:51PM -0700, Justin TerAvest wrote:

[..]
> > Ok, In the past I had tried it with 2 cgroups (running dd inside these
> > cgroups) and I had no success. I am wondering what has changed.
> 
> It could just be a difference in workload, or dd size, or filesystem?

Once you have sorted out the bug and I can boot my system, I will test
it to see what's happening.

> 
> >
> > In the past a high priority throttled process can very well try to
> > pick up a inode from low prio cgroup and start writting it and get
> > blocked. I believe similar thing should happen now.
> 
> You're right that it's very dependent on what inodes get picked up
> when from writeback.

So then above results should not be reproducible consistently? Are you
using additional patches internally to make this work reliably. My
concenrn is that it will not make sense to have half baked pieces 
in upstream kernel. That's why I was hoping that this piece can go in
once we have sorted out following.

- IO less throttling
- Per cgroup dirty ratio
- Some work w.r.t cgroup aware writeback.

In fact cgroup aware writeback can be part of this patch series once
first two pieces are in the kernel.

Thanks
Vivek
