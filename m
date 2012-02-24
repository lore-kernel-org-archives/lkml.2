Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab2BXVpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 16:45:36 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64217 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766Ab2BXVpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 16:45:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rientjes@google.com designates 10.68.218.228 as permitted sender) smtp.mail=rientjes@google.com; dkim=pass header.i=rientjes@google.com
Date: Fri, 24 Feb 2012 13:45:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josef Bacik <josef@redhat.com>
cc: Rafael Aquini <aquini@redhat.com>, linux-mm@kvack.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom: add sysctl to enable slab memory dump
In-Reply-To: <20120224151025.GA1848@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1202241342240.22880@chino.kir.corp.google.com>
References: <20120222115320.GA3107@x61.redhat.com> <alpine.DEB.2.00.1202221640420.14213@chino.kir.corp.google.com> <20120223150238.GA15427@dhcp231-144.rdu.redhat.com> <alpine.DEB.2.00.1202231505080.26362@chino.kir.corp.google.com>
 <20120224151025.GA1848@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Feb 2012, Josef Bacik wrote:

> Um well yeah, I'm rewriting a chunk of btrfs which was rapantly leaking memory
> so the OOM just couldn't keep up with how much I was sucking down.  This is
> strictly a developer is doing something stupid and needs help pointing out what
> it is sort of moment, not a day to day OOM.
>  

If you're debugging new kernel code and you realize that excessive amount 
of memory is being consumed so that nothing can even fork, you may want to 
try cat /proc/slabinfo before you get into that condition the next time 
around, although I already suspect that you know the cache you're leaking.  
It doesn't mean we need to add hundreds of lines of code to the kernel.  
Try kmemleak.
