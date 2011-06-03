Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab1FCSKK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:10:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33165 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab1FCSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qHvLMl9PuQvlY3srYDsQcHTiWg/XpZXfHaVVgl4fBQ4F+uZO6KDH1H6yFiat+r2OE2
         r1+O8mYP/p1KZ25uLSexwsX2vdbVWS7Cvzi8JtNKM0QRhWHaIk3xyVaDzUQdnRqbKbF/
         SsTd4bozWjX72W+vxUYtuf2Z37D9tYinR42Gk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: thread leader death under strace (was Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE)
Date: Fri, 3 Jun 2011 20:10:03 +0200
User-Agent: KMail/1.8.2
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        indan@nul.nu, bdonlan@gmail.com, linux-kernel@vger.kernel.org,
        jan.kratochvil@redhat.com, akpm@linux-foundation.org
References: <BANLkTin1q-r=b3ZVbT3vdJ59OEddrRWfsQ@mail.gmail.com> <201106030026.18523.vda.linux@googlemail.com> <20110603152937.GB23757@redhat.com>
In-Reply-To: <20110603152937.GB23757@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201106032010.03947.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 June 2011 17:29, Oleg Nesterov wrote:
> > > > > thread_leader(void *unused)
> > > > > {
> > > > > 	/* malloc gives sufficiently aligned buffer.
> > > > > 	 * long buf[] does not! (on ia64).
> > > > > 	 */
> > > > > 	clone2(thread1, malloc(16 * 1024), 16 * 1024, 0
> > > >
> > > > Probably because of this clone2.
> >
> > This seems to be not a problem (it is defined to clone()).
> 
> Doesn't matter.
> 
> Unlike pthread_create() which uses CLONE_SETTLS, this doesn't setup
> the tls area, and I assume you used -lpthread. In this case it is clear
> why raise() doesn't work, pt-raise.c thinks that THREAD_GETMEM(tid)
> should always work.

I don't link against pthread.

-- 
vda
