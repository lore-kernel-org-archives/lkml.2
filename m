Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab1D3MRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:17:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62654 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1D3MRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t+jm2gBJiWKJJUh0N4kr6uY72GKmzx6q3TL/9cPibmA4z13Q9m1t9W5Q9mNNd1GR+b
         irva67weI65BzdfYIOtQvnU0EeXsr5Npwei/1qVJg7aHjPdP33TPC/YTn2G/NcuE9KKc
         NTh64xZj7FJu6ncY2FZOI41pi3dwtOawMolu0=
Date: Sat, 30 Apr 2011 14:17:34 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, rientjes@google.com, tglx@linutronix.de, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET tip] x86, NUMA: Unify 32 and 64bit NUMA
 initialization
Message-ID: <20110430121734.GF29280@htj.dyndns.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
 <4DBB1C16.3070307@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBB1C16.3070307@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Yinghai.

Nice catch, but,

On Fri, Apr 29, 2011 at 01:14:14PM -0700, Yinghai Lu wrote:
> [PATCH] x86, numa: Trim numa meminfo correctly
> 
> During testing 32bit numa unifying code from tj, found one system with more than 64g
> fail to use numa.
> 
> It turn out we do not trim that numa meminfo correctly with max_pfn.
> start could be bigger than 64g too.
> 
> Also need to make the checking in seperated loop.

Why?

Isn't all that necessary the following?

---
 arch/x86/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/arch/x86/mm/numa.c
===================================================================
--- work.orig/arch/x86/mm/numa.c
+++ work/arch/x86/mm/numa.c
@@ -278,7 +278,7 @@ int __init numa_cleanup_meminfo(struct n
 		bi->end = min(bi->end, high);
 
 		/* and there's no empty block */
-		if (bi->start == bi->end) {
+		if (bi->start >= bi->end) {
 			numa_remove_memblk_from(i--, mi);
 			continue;
 		}
