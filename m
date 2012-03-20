Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab2CTQBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:01:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39265 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab2CTQB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:01:29 -0400
Date: Tue, 20 Mar 2012 09:01:21 -0700
From: Tejun Heo <tj@kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: glommer@parallels.com, lizf@cn.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, rni@google.com,
        ctalbott@google.com
Subject: Re: [PATCH 07/10] cgroup: remove cgroup_add_file[s]()
Message-ID: <20120320160121.GC5684@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
 <1331940963-15756-8-git-send-email-tj@kernel.org>
 <87aa3bu094.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aa3bu094.fsf@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 02:17:51PM +0530, Aneesh Kumar K.V wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > No controller is using cgroup_add_files[s]().  Unexport them, and
> > convert cgroup_add_files() to handle NULL entry terminated array
> > instead of taking count explicitly and continue creation on failure
> > for internal use.
> >
> 
> I am planning to use that in the HugeTLB extension of memcg.
> 
> http://article.gmane.org/gmane.linux.kernel.mm/75470
> 
> We need to have different limit and usage file for different HugeTLB
> page size supported.

Unless you have to alter available files cgroup-by-cgroup, you should
be fine.  If you're trying to create different set of files depending
on cgroup, it's confusing - change your interface.

Thanks.

-- 
tejun
