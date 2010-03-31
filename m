Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab0CaV7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:59:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab0CaV7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:59:09 -0400
Date: Wed, 31 Mar 2010 14:58:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>, steffen.klassert@secunet.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: section cleanup
Message-Id: <20100331145817.bd0a1a08.akpm@linux-foundation.org>
In-Reply-To: <20100329081550.GA22334@gondor.apana.org.au>
References: <1269672826-1102-1-git-send-email-henne@nachtwindheim.de>
	<20100329081550.GA22334@gondor.apana.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 16:15:50 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Sat, Mar 27, 2010 at 07:53:46AM +0100, Henrik Kretzschmar wrote:
> > This patch removes the __cupinit from padata_cpu_callback(),
> > which is refered by the exportet function padata_alloc().
> > 
> > This could lead to problems if CONFIG_HOTPLUG_CPU is disabled,
> > which should happen very often.
> > 
> > WARNING: kernel/built-in.o(.text+0x7ffcb): Section mismatch in reference from the function padata_alloc() to the function .cpuinit.text:padata_cpu_callback()
> > The function padata_alloc() references
> > the function __cpuinit padata_cpu_callback().
> > This is often because padata_alloc lacks a __cpuinit
> > annotation or the annotation of padata_cpu_callback is wrong.
> > 
> > Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> 
> Patch applied.  Thanks!

(wtf?)

OK, on behalf of thousands I ask: what the heck is kernel/padata.c? 

Seems to have popped up in 2.6.34, positioned as generic kernel-wide
code only it has been secreted away on the linux-crypto list.  Please
don't do this.

What is it for, how does it work, where might it otherwise be used,
what are the dynamics, why does it use softirqs rather than (say)
kernel threads and how do we stop it from using yield()?

