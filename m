Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0DIQtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 12:49:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:55022 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab0DIQtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 12:49:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=LQbhoRXSj66BLA4Mu0tQ+rq+6cSa+XImRNhaqFy48rLtW7TAbGQ1agKT7M7yUWxfg
	/tjaij11RwebJnyzvNd3A==
Date: Fri, 9 Apr 2010 09:49:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Xiaotian Feng <dfeng@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] slab: fix caller tracking on !CONFIG_DEBUG_SLAB &&
 CONFIG_TRACING
In-Reply-To: <4BBEC92B.9060407@redhat.com>
Message-ID: <alpine.DEB.2.00.1004090947030.10992@chino.kir.corp.google.com>
References: <1270721493-27820-1-git-send-email-dfeng@redhat.com> <alpine.DEB.2.00.1004081209380.21040@chino.kir.corp.google.com> <4BBEC92B.9060407@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Xiaotian Feng wrote:

> > This doesn't work if the underlying slab allocator doesn't define
> > __kmalloc_node_track_caller() regardless of whether CONFIG_TRACING is
> > enabled or not.  SLOB, for example, never defines it, and that's why the
> > conditional exists in the way it currently does.
> > 
> 
> Sorry, I didn't realized this, can we use (defined(CONFIG_TRACING) &&
> defined(CONFIG_SLAB)) ?
> 

The valid configurations are

	(CONFIG_SLAB && (CONFIG_DEBUG_SLAB || CONFIG_TRACING)) || CONFIG_SLUB
