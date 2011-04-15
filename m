Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab1DOXfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:35:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24838 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1DOXfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:35:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Qxbtj/dQBPCTA+I3ZHqRQ8XntLvFe//Acf2adJPBfEHiDjqHebznaW1VHH4a7yNNbt
         U70HB7+iKlaTVm26/hrA==
Date: Fri, 15 Apr 2011 16:35:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Namhyung Kim <namhyung@gmail.com>
cc: Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mempolicy: reduce references to the current
In-Reply-To: <1302847688-8076-1-git-send-email-namhyung@gmail.com>
Message-ID: <alpine.DEB.2.00.1104151634050.3847@chino.kir.corp.google.com>
References: <BANLkTinDFrbUNPnUmed2aBTu1_QHFQie-w@mail.gmail.com> <1302847688-8076-1-git-send-email-namhyung@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Namhyung Kim wrote:

> Remove duplicated reference to the 'current' task using a local
> variable. Since refering the current can be a burden, it'd better
> cache the reference, IMHO. At least this saves some bytes on x86_64.
> 
>   $ size mempolicy-{old,new}.o
>      text    data    bss     dec     hex filename
>     25203    2448   9176   36827    8fdb mempolicy-old.o
>     25136    2448   9184   36768    8fa0 mempolicy-new.o
> 

So this is the opposite of what Andrew did in c06b1fca18c3 
(mm/page_alloc.c: don't cache `current' in a local) for the page 
allocator?
