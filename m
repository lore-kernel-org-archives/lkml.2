Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935426Ab1ETJH1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:07:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41613 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935009Ab1ETJHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e0xu3kEDoTGF0ftsU0klHyarklyhGC9c/Ir65JeyDSfhAKfm3VkYnpuWEfm+NBFevB
         FyuMyCwhkftKOVU8g8pQtHReQmQOBUl4UM/m0uFhG5BT4NhLf+RE5C9geLH2eV28VBwc
         nX16Ci3zh2RTKKnqvKZ0Zrs3DBOcqZMNbzHwg=
Date: Fri, 20 May 2011 11:07:18 +0200
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110520090718.GC31426@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <201105192031.33569.pedro@codesourcery.com>
 <201105200042.12230.vda.linux@googlemail.com>
 <201105200000.18310.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105200000.18310.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pedro.

On Fri, May 20, 2011 at 12:00:17AM +0100, Pedro Alves wrote:
> > > UUIC, that opens a race where between SEIZEing and
> > > SETOPTIONS(O_TRACE FORK|VFORK|EXEC...), the tracee can
> > > fork/vfork/clone/exec, without the tracer getting the
> > > nice corresponding PTRACE_EVENT_ events.

Does it matter?  The order of execution isn't even well defined
without synchronization border.  If you want full synchronization, you
can INTERRUPT tracee.

>  SEIZE,execvd,INTERRUPT (SETOPTS on interrupt)
> 
> will make the tracer see a SIGTRAP that 
> 
>  execvd,SEIZE,INTERRUPT
> 
> nor
> 
>  SEIZE,SETOPTS,execvd (SETOPTS on interrupt)
> 
> would cause, isn't it?

Yes, SIGTRAP on exec(2) is nasty but also is scheduled to be removed
if SEIZED.

> Now, if it were possible for the tracer to set the
> default OPTS _before_ PTRACE_ATTACH/PTRACE_SEIZE...

I don't see why that would be necessary.

Thanks.

-- 
tejun
