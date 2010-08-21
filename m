Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab0HUHjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 03:39:36 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56342 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0HUHje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 03:39:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TjXWcw5UlXGVe34BXx8qcCJaNRUsRfLWNPo1WbVSt7+XRkVqjM4aPARONHVal284QJ
         0SvoawsFcWuxP3BcRzVkUpiiAovmQ7pPs/48rAFKuiG7IZ7oRtuBBw8DV5rBfmRX1WSe
         1uXhDAqup501lmov+gQHWk0sPuGmSikXgDIbI=
Date: Sat, 21 Aug 2010 00:39:27 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: linux-next: build failure after merge of the final tree (input
 tree related)
Message-ID: <20100821073927.GA2160@core.coreip.homeip.net>
References: <20100820131224.02f7cb9f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820131224.02f7cb9f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Aug 20, 2010 at 01:12:24PM +1000, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> After merging the final tree, today's linux-next build (i386 defconfig)
> failed like this:
> 
> In file included from drivers/gpu/drm/i915/i915_irq.c:29:
> include/linux/sysrq.h:45: error: expected declaration specifiers or '...' before 'bool'
> 
> Caused by commit a821bafce37b26499e2bfbf2e6b96b0636efc014 ("Input: sysrq
> - drop tty argument form handle_sysrq()") from the input tree which
> (despite not mentioning this) changed an "int" argument to "bool" but
> neglected to include linux/types.h.
> 
> I added this patch for today:

Thank you very much for the patch. I folded it into original patch to
avoid build failures in case someone needs to bisect.

-- 
Dmitry
