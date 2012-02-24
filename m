Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2BXCtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 21:49:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54323 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2BXCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 21:49:13 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 24 Feb 2012 11:47:48 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Arun Sharma <asharma@fb.com>
Cc: Balbir Singh <bsingharora@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
Message-Id: <20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4F468888.9090702@fb.com>
References: <1326912662-18805-1-git-send-email-asharma@fb.com>
	<CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com>
	<4F468888.9090702@fb.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 10:42:16 -0800
Arun Sharma <asharma@fb.com> wrote:

> Hi Balbir,
> 
> Thanks for reviewing. Would you change your position if I limit the 
> scope of the patch to a cgroup with a single address space?
> 
> The moment the cgroup sees more than one address space (either due to 
> tasks getting created or being added), this optimization would be turned 
> off.
> 
> More details below:
> 
> On 2/22/12 11:45 PM, Balbir Singh wrote:
> >
> > So the assumption is that only apps that have access to each others
> > VMA's will run in this cgroup?
> >
> 
> In a distributed computing environment, a user submits a job to the 
> cluster job scheduler. The job might involve multiple related 
> executables and might involve multiple address spaces. But they're 
> performing one logical task, have a single resource limit enforced by a 
> cgroup.
> 
> They don't have access to each other's VMAs, but if "accidentally" one 
> of them comes across an uninitialized page with data from another task, 
> it's not a violation of the security model.
> 
How do you handle shared resouce, file-cache ?

Thanks,
-Kame

