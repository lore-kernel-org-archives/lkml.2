Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab0KDBuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 21:50:22 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab0KDBuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=vFbPO2n6/5bW90pDLSUfmmcQML7shX5XV6Yu+iVG6SICgdcCTUfUqJbhGT2SxuNeMO
         2iMjShO3BnDqzp1NuQMw==
Date: Wed, 3 Nov 2010 18:50:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
cc: figo zhang <figo1802@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re:[PATCH v2]oom-kill: CAP_SYS_RESOURCE should get bonus
In-Reply-To: <1288834737.2124.11.camel@myhost>
Message-ID: <alpine.DEB.2.00.1011031847450.21550@chino.kir.corp.google.com>
References: <1288662213.10103.2.camel@localhost.localdomain> <1288827804.2725.0.camel@localhost.localdomain> <alpine.DEB.2.00.1011031646110.7830@chino.kir.corp.google.com> <AANLkTimjfmLzr_9+Sf4gk0xGkFjffQ1VcCnwmCXA88R8@mail.gmail.com>
 <1288834737.2124.11.camel@myhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Figo.zhang wrote:

> > > CAP_SYS_RESOURCE also had better get 3% bonus for protection.
> > >
> > 
> > 
> > Would you like to elaborate as to why?
> > 
> > 
> 
> process with CAP_SYS_RESOURCE capibility which have system resource
> limits, like journaling resource on ext3/4 filesystem, RTC clock. so it
> also the same treatment as process with CAP_SYS_ADMIN.
> 

NACK, there's no justification that these tasks should be given a 3% 
memory bonus in the oom killer heuristic; in fact, since they can allocate 
without limits it is more important to target these tasks if they are 
using an egregious amount of memory.  CAP_SYS_RESOURCE threads have the 
ability to lower their own oom_score_adj values, thus, they should protect 
themselves if necessary like everything else.
