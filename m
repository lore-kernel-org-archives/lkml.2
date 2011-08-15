Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab1HOXGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 19:06:11 -0400
Received: from smtp-out.google.com ([74.125.121.67]:63324 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab1HOXGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 19:06:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=pKRPBctLhFKl7ZWOt1R0itxh2y4ufDQ73p9iaN1T5aLvtaZR/ai/6yk/MSvRHWcL7
	tdihSFDyFgrjlEk6ER+zQ==
Date: Mon, 15 Aug 2011 16:06:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pavel Roskin <proski@gnu.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Suppressing a plus from setlocalversion
In-Reply-To: <20110815173706.12ccfdd4@mj>
Message-ID: <alpine.DEB.2.00.1108151600400.22798@chino.kir.corp.google.com>
References: <20110815173706.12ccfdd4@mj>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Aug 2011, Pavel Roskin wrote:

> Hello!
> 
> There is one annoyance in the build system that I cannot work around.

That's surprising since you actually state the workaround, i.e. using 
LOCALVERSION= with make, yourself.

> Before I attempt hacking the code, I'd like to make sure I'm not
> missing anything obvious.
> 
> Suppose that I have a kernel version 3.1-rc2.  I want to test some patch
> for some code that is compiled as a module.  I change the code and
> create a patch with STGit.  I recompile the modules, install them by
> "make module_install", unload the module I patched, load it again
> and find that there is no effect from my change.  It turns out that the
> modules were installed to "/lib/modules/3.1.0-rc2+" and the plus was
> added by scripts/localversion because the source tree is now modified.
> 

Yes, because the kernel you've produced is no longer 3.1.0-rc2, it is 
modified.  If you want to do something else locally, then you can always 
use LOCALVERSION=.

The + was added to stop falsely identifying kernels as a specific version 
when they are modified by default.  Sorry if you forget to override it 
sometimes.
