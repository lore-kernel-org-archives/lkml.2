Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0HDEev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 00:34:51 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27016 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab0HDEeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 00:34:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=fUwKD0CBzswPSJj3aXENMjRhesJj/jbVDIXJJ9xucNd8w3Wxca1Q+kQ9YgtkL+Ijs
	RV/FXMv1CRZF/4tjkENZQ==
MIME-Version: 1.0
In-Reply-To: <20100804043328.GB11950@ghc17.ghc.andrew.cmu.edu>
References: <20100730235649.GA22644@ghc17.ghc.andrew.cmu.edu>
	<20100730235754.GB22644@ghc17.ghc.andrew.cmu.edu>
	<AANLkTikpNG2Y3S3AyxAbCkMynKu1u5yKPrw=bh+uy=9R@mail.gmail.com>
	<20100804043328.GB11950@ghc17.ghc.andrew.cmu.edu>
Date: Tue, 3 Aug 2010 21:34:22 -0700
Message-ID: <AANLkTi=dhym3c+XJVjoObROcw=mz2Y+a2R5oMdePK3Ng@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] cgroups: read-write lock CLONE_THREAD forking per 
	threadgroup
From: Paul Menage <menage@google.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, ebiederm@xmission.com,
        lizf@cn.fujitsu.com, matthltc@us.ibm.com, oleg@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 3, 2010 at 9:33 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
>> As far as the #ifdef mess goes, it's true that some people don't have
>> CONFIG_CGROUPS defined. I'd imagine that these are likely to be
>> embedded systems with a fairly small number of processes and threads
>> per process. Are there really any such platforms where the cost of a
>> single extra rwsem per process is going to make a difference either in
>> terms of memory or lock contention? I think you should consider making
>> these additions unconditional.
>
> That's certainly an option, but I think it would be clean enough to put
> static inline functions just under the signal_struct definition.

Either sounds fine to me. I suspect others have a stronger opinion.

Paul
