Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834Ab2JEU7g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 16:59:36 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57793 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932409Ab2JEU7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 16:59:32 -0400
X-Originating-IP: 217.70.178.139
X-Originating-IP: 173.246.103.110
Date: Fri, 5 Oct 2012 13:59:22 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: danielfsantos@att.net
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v2 07/10] compiler.h, bug.h: Prevent double error
 messages with BUILD_BUG{,_ON}
Message-ID: <20121005205922.GA7362@jtriplet-mobl1>
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com>
 <1349466169-20637-7-git-send-email-daniel.santos@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349466169-20637-7-git-send-email-daniel.santos@pobox.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 02:42:46PM -0500, danielfsantos@att.net wrote:
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -296,6 +296,11 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
>  #endif
>  #ifndef __compiletime_error
>  # define __compiletime_error(message)
> +# define __compiletime_error_fallback(condition) \
> +	 ((void)sizeof(char[1 - 2*!!(condition)]))
> +#endif
> +#ifndef __compiletime_error_fallback
> +# define __compiletime_error_fallback(condition) (void)(0)

Might want to use do { } while (0) here, to force the use of a
semicolon and avoid the use of __compiletime_error_fallback in an
expression.

- Josh Triplett
