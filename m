Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935498Ab1ETJbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:31:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57788 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933718Ab1ETJbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:31:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=imJ2Zn9cOfG6ZwJmuqUaWD17vfrx+XYffUZyewLEass4hIZeOOv53Y6uT8uBb51ej2
         cUtz795CbmOCuuurVXfpdCxW17PmqDZ6iwebCEZQtxZRg1rfXjvIIEYYQVH906t00DEC
         yeVwiaaw/kxXEgZskr5k5icP+/0Ksl8EekKyk=
Date: Fri, 20 May 2011 11:31:11 +0200
From: Tejun Heo <tj@kernel.org>
To: Pedro Alves <pedro@codesourcery.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, oleg@redhat.com,
        jan.kratochvil@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu,
        bdonlan@gmail.com
Subject: Re: [PATCH 03/10] ptrace: implement PTRACE_SEIZE
Message-ID: <20110520093111.GG31426@htj.dyndns.org>
References: <1305569849-10448-1-git-send-email-tj@kernel.org>
 <201105200000.18310.pedro@codesourcery.com>
 <20110520090718.GC31426@htj.dyndns.org>
 <201105201027.36688.pedro@codesourcery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105201027.36688.pedro@codesourcery.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Pedro.

On Fri, May 20, 2011 at 10:27:35AM +0100, Pedro Alves wrote:
> > Does it matter?  The order of execution isn't even well defined
> > without synchronization border.  If you want full synchronization, you
> > can INTERRUPT tracee.
> 
> The point I was trying to raise was not about the order of
> execution, but about letting the old pre-nice PTRACE_EVENT_
> events quirks stick through.

I see.

> > Yes, SIGTRAP on exec(2) is nasty but also is scheduled to be removed
> > if SEIZED.
> 
> Okay, good to hear that.  Looks like the tracer can do:
> 
>  SEIZE,execve,SETOPTS,'readlink /proc/pid/exe'
> 
> and pretend it SEIZED after the execve.

Yeap, and I was trying to say that if tracer and tracee are running on
different CPUs, the order between SEIZE and execve isn't even well
defined (sans the nasty automatic SIGTRAP).

> I'm happy for now.

Awesome, thanks.

-- 
tejun
