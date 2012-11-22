Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab2KVTHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:07:30 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40171 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab2KVTHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:07:25 -0500
Date: Thu, 22 Nov 2012 14:43:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v6 8/9] compiler.h, bug.h: Prevent double error messages
 with BUILD_BUG{,_ON}
Message-ID: <20121122134342.GD17147@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Daniel Santos <daniel.santos@pobox.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christopher Li <sparse@chrisli.org>,
	David Daney <david.daney@cavium.com>,
	David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
	Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
	Michel Lespinasse <walken@google.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Steven Rostedt <rostedt@goodmis.org>
References: <1353444132-6809-1-git-send-email-daniel.santos@pobox.com>
 <1353445507-7233-8-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1353445507-7233-8-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 03:05:06PM -0600, danielfsantos@att.net wrote:
> Prior to the introduction of __attribute__((error("msg"))) in gcc 4.3,
> creating compile-time errors required a little trickery.
> BUILD_BUG{,_ON} uses this attribute when available to generate
> compile-time errors, but also uses the negative-sized array trick for
> older compilers, resulting in two error messages in some cases.  The
> reason it's "some" cases is that as of gcc 4.4, the negative-sized array
> will not create an error in some situations, like inline functions.
> 
> This patch replaces the negative-sized array code with the new
> __compiletime_error_fallback() macro which expands to the same thing
> unless the the error attribute is available, in which case it expands to
> do{}while(0), resulting in exactly one compile-time error on all
> versions of gcc.
> 
> Note that we are not changing the negative-sized array code for the
> unoptimized version of BUILD_BUG_ON, since it has the potential to catch
> problems that would be disabled in later versions of gcc were
> __compiletime_error_fallback used.  The reason is that that an
> unoptimized build can't always remove calls to an error-attributed
> function call (like we are using) that should effectively become dead
> code if it were optimized.  However, using a negative-sized array with a
> similar value will not result in an false-positive (error). The only
> caveat being that it will also fail to catch valid conditions, which we
> should be expecting in an unoptimized build anyway.
> 
> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
Boris.
