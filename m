Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab2CIFBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 00:01:19 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:43574 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab2CIFBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 00:01:18 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tyler Hicks <tyhicks@canonical.com>, linux-mm@kvack.org, davej@redhat.com,
        jboyer@redhat.com, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
In-Reply-To: <20120308141938.1d04afb7.akpm@linux-foundation.org>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120308130256.c7855cbd.akpm@linux-foundation.org> <20120308211926.GB6546@boyd> <20120308134050.f53a0b2f.akpm@linux-foundation.org> <20120308214951.GB23916@ZenIV.linux.org.uk> <20120308141938.1d04afb7.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 09 Mar 2012 10:30:53 +0530
Message-ID: <87y5ra8j22.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12030818-1396-0000-0000-000000CA773D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 14:19:38 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 8 Mar 2012 21:49:52 +0000
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > > So we need to pull the i_mutex out of hugetlbfs_file_mmap().
> > 
> > IIRC, you have a patch in your tree doing just that...
> 
> Nope.
> 
> But it seems that you've recently seen such a patch - can you recall
> where?  Or was it the ecryptfs thing?
> 

So what we ended up doing was

http://article.gmane.org/gmane.linux.kernel.mm/74732

The patch update hugetlbfs_read to not take i_mutex. That should make
sure deadlock won't happen. 


-aneesh

