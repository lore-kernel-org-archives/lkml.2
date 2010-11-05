Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0KESUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 14:20:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56411 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0KESU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SvKIDOmebcWBf8iH8ZdRVF6wr00D/cyE9/olxONI3nM/PY6tmGxFIYy2v3AFkkkKtK
         gpFLLY4s3O4kgWGTQ4UhTz5/2ESIffdNOjkoUzue/mn737vfWuxENS8KyDOU4IM8mvYY
         enNoP6yuLWgBFUUF/1RdKSlZweuxz6itYF144=
Subject: Re: [PATCH] atomic: add atomic_inc_not_zero_hint()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <20101105110828.52f061b3.akpm@linux-foundation.org>
References: <1288975980.2882.877.camel@edumazet-laptop>
	 <20101105102038.53e36f9e.akpm@linux-foundation.org>
	 <1288980046.2882.1054.camel@edumazet-laptop>
	 <20101105110828.52f061b3.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 19:20:24 +0100
Message-ID: <1288981224.2882.1105.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 05 novembre 2010 à 11:08 -0700, Andrew Morton a écrit :
> On Fri, 05 Nov 2010 19:00:46 +0100
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Le vendredi 05 novembre 2010 __ 10:20 -0700, Andrew Morton a __crit :
> > 
> > > It totally makes sense to add include/linu/atomic.h for common things. 
> > > Perhaps there's already code in arch/*/include/asm/atomic.h which
> > > should be hoisted up there.  But that can't reliably be done until a
> > > million files have had their #includes switched :(
> > > 
> > 
> > Maybe including <linux/atomic.h> only from the end of various
> > 
> > arch/*/include/asm/atomic.h  ?
> 
> heh, I guess that would work.  It breaks the standard way of doing
> these things (I think?) so let's not go there unless we have a need?
> 
> > In this case, I remove the include <asm/atomic.h> from linux/atomic.h
> 
> Oh.  Why?  I thought it was better the previous, standard way: thou
> shalt henceforth include liunx/atomic.h, not asm/atomic.h.  And the
> presence of linux/atomic.h will in fact trigger the checkpatch warning
> telling people to use that when they try to use asm/atomic.h.

Hmm, if we want to move the common stuff from
arch/*/include/asm/atomic.h to this new file (include/linux/atomic.h),
then we would have to change hundred of 

#include <asm/atomic.h> 

to

#include <linux/atomic.h> 

This seems a big task to me ?

Or just make a whole tree replace ?



