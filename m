Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab1KRXxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:53:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49650 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1KRXxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:53:04 -0500
Date: Fri, 18 Nov 2011 15:53:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Miao Xie <miaox@cn.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch v2 for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
In-Reply-To: <20111117160019.c8bd45ba.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1111181549460.24487@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com> <20111117142213.2b34469d.akpm@linux-foundation.org> <alpine.DEB.2.00.1111171507340.9933@chino.kir.corp.google.com> <20111117160019.c8bd45ba.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011, Andrew Morton wrote:

> Nothing in this changelog makes me understand why you think we need this
> change in 3.2.  What are the user-visible effects of this change?
> 

Kernels where MAX_NUMNODES > BITS_PER_LONG may temporarily see an empty 
nodemask in a tsk's mempolicy if its previous nodemask is remapped onto a 
new set of allowed cpuset nodes where the two nodemasks, as a result of 
the remap, are now disjoint.  This fix is a bandaid so that we never 
optimize the stores to tsk->mems_allowed because they intersect if tsk 
also has an existing mempolicy, so that prevents the possibility of seeing 
an empty nodemask during rebind.  For 3.3, I'd like to ensure that 
remapping any mempolicy's nodemask will never result in an empty nodemask.
