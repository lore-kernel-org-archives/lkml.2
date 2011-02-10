Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab1BJNTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:19:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1BJNTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:19:54 -0500
Date: Thu, 10 Feb 2011 14:19:28 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael J Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 1/5] pagewalk: only split huge pages when necessary
Message-ID: <20110210131928.GV3347@random.random>
References: <20110209195406.B9F23C9F@kernel>
 <20110209195407.2CE28EA0@kernel>
 <20110210111125.GC17873@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110210111125.GC17873@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 11:11:25AM +0000, Mel Gorman wrote:
> Before we goto this retry, there is at a cond_resched(). Just to confirm,
> we are depending on mmap_sem to prevent khugepaged promoting this back to
> a hugepage, right? I don't see a problem with that but I want to be
> sure.

Correct, and we depend on that everywhere as wait_split_huge_page has
to run without holding spinlocks.
