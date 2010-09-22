Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096Ab0IVQrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:47:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39077 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab0IVQrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:47:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nSRgBnFXHuvAL/0zpwk3ykSjB+bWK5LhAhNd37bGiJqLhhzLiFum8UQLTCWwhXNWLz
         naUs2MDYURnLYy10oX1r+shRGAm2TU10hMEbzz+uA5nDE966vBIi+bWBkk8E/bRPs7Kn
         hh9O710naC0bCkOPZOZ86eqBtUvk2qtjFQ6Sw=
Date: Wed, 22 Sep 2010 18:47:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] avoid second smp_processor_id() call in
	__touch_watchdog
Message-ID: <20100922164703.GD5302@nowhere>
References: <20100813102158.GA5434@swordfish.minsk.epam.com> <20100818123346.02028e96.akpm@linux-foundation.org> <20100922090012.GA5459@swordfish.minsk.epam.com> <20100922162730.GC5302@nowhere> <1285173559.2275.1024.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285173559.2275.1024.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 06:39:19PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-09-22 at 18:27 +0200, Frederic Weisbecker wrote:
> > 
> > I'm not sure we want this. This is called by the watchdog internally,
> > from the timer or the cpu bound thread, so we probably should better
> > keep __get_cpu_var() because it checks that we are not in a preemptable
> > section. 
> 
> The smp_processor_id() right at the start already does that.
> 
> That said, I doubt it really matter one way or the other, compilers have
> been known to do CSE for quite a while.


I don't mind personally. We indeed have this smp_processor_id() that
does the check already. But that's also for readability: reviewers
that are used to deal with per cpu datas are also used to see
per_cpu() for remote percpu data access and get_cpu_var() for local
percpu.

Plus some archs may override their __my_cpu_offset implementation
to provide a faster access.

