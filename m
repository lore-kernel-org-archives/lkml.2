Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2HTJmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:42:38 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59164 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab2HTJmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:42:35 -0400
Date: Mon, 20 Aug 2012 11:42:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org,
        JBeulich@suse.com, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 46/74] x86, lto: Disable fancy hweight optimizations for LTO
Message-ID: <20120820094234.GB16230@one.firstfloor.org>
References: <1345345030-22211-1-git-send-email-andi@firstfloor.org> <1345345030-22211-47-git-send-email-andi@firstfloor.org> <50320027.1010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50320027.1010809@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  config ARCH_HWEIGHT_CFLAGS
> >  	string
> > -	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32
> > -	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64
> > +	default "-fcall-saved-ecx -fcall-saved-edx" if X86_32 && !LTO
> > +	default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11" if X86_64 && !LTO
> > +	default "" if LTO
> >  
> 
> Seems heavy handed.  How about using __attribute__((optimize(...))) instead?

Doesn't work for this. In fact according to the gcc developers that
attribute is mostly broken.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
