Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404Ab0HQTCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:02:31 -0400
Received: from smtp-out.google.com ([216.239.44.51]:7033 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762296Ab0HQTC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:02:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=S8Ok3UsgcoysgjitUz3xLM2dyMEBSpAgQYqFKnOWSr9PfrhPi2PenxxvPKeWXZxFW
	KEZUiMcKlGdWxaAROwVhA==
Date: Tue, 17 Aug 2010 12:02:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>
Subject: Re: [S+Q3 20/23] slub: Shared cache to exploit cross cpu caching
 abilities.
In-Reply-To: <alpine.DEB.2.00.1008171348220.13665@router.home>
Message-ID: <alpine.DEB.2.00.1008171158530.21770@chino.kir.corp.google.com>
References: <20100804024514.139976032@linux.com> <20100804024535.338543724@linux.com> <alpine.DEB.2.00.1008162246500.26781@chino.kir.corp.google.com> <alpine.DEB.2.00.1008171234130.12188@router.home> <alpine.DEB.2.00.1008171137030.6486@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1008171348220.13665@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Christoph Lameter wrote:

> Well yes I guess that is the result of large scale corruption that is
> reaching into the debug fields of the object.
> 
> > [   15.752467]
> > [   15.752467] INFO: 0xffff880c7e5f3ec0-0xffff880c7e5f3ec7. First byte 0x30 instead of 0xbb
> > [   15.752467] INFO: Allocated in 0xffff88087e4f11e0 age=131909211166235 cpu=2119111312 pid=-30712
> > [   15.752467] INFO: Freed in 0xffff88087e4f13f0 age=131909211165707 cpu=2119111840 pid=-30712
> > [   15.752467] INFO: Slab 0xffffea002bba4d28 objects=51 new=3 fp=0x0007000000000000 flags=0xa00000000000080
> > [   15.752467] INFO: Object 0xffff880c7e5f3eb0 @offset=3760
> > [   15.752467]
> > [   15.752467] Bytes b4 0xffff880c7e5f3ea0:  18 00 00 00 7e 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a ....~...ZZZZZZZZ
> > [   15.752467]   Object 0xffff880c7e5f3eb0:  d0 0f 4f 7e 08 88 ff ff 80 10 4f 7e 08 88 ff ff .O~....O~..
> > [   15.752467]  Redzone 0xffff880c7e5f3ec0:  30 11 4f 7e 08 88 ff ff                         0.O~..
> > [   15.752467]  Padding 0xffff880c7e5f3ef8:  00 16 4f 7e 08 88 ff ff                         ..O~..
> 
> 16 bytes allocated and a pointer array much larger than that is used.
> 

Since the problem persists with and without CONFIG_SLUB_DEBUG_ON, I'd 
speculate that this is a problem with node scalability on my 4-node system 
if this boots fine for you.
