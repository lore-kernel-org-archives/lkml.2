Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1D1VZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:25:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32480 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1D1VZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:25:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Vwxnywqhn46Mqsl502eTu0LLmsZbNg9N7bQVBDg4LWiIX2kC9iyzkH6ERrsCDjCEHV
         ZbueMxeA8Ldw+HoE3t6A==
Date: Thu, 28 Apr 2011 14:25:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@suse.de>, linux-m68k@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] m68k SLUB fix for 2.6.39
In-Reply-To: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1104281420140.21665@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104282000200.1563@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Apr 2011, Geert Uytterhoeven wrote:

> 	Hi Linus,
> 
> This is the SLUB fix for m68k, which also applies to stable.
> 
> The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:
>   Linus Torvalds (1):
>         Linux 2.6.39-rc5
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-2.6.39
> 
> Michael Schmitz (1):
>       m68k/mm: Set all online nodes in N_NORMAL_MEMORY
> 
>  arch/m68k/mm/motorola.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 

Thanks for pushing this, Geert.

Since 4a5fa3590f09 ([PARISC] slub: fix panic with DISCONTIGMEM) from 
2.6.39-rc4, you can't actually select slub on m68k without CONFIG_ADVANCED 
and CONFIG_SINGLE_MEMORY_CHUNK because it otherwises defaults to 
discontigmem.

James tested hppa64 with my N_NORMAL_MEMORY fix and found that it turned 
an SMP box into UP.  If you've tested slub on m68k without regressions, 
then perhaps you'd like to add a "|| M68K" to CONFIG_SLUB?
