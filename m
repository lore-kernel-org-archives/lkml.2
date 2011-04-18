Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1DRX6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 19:58:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59418 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1DRX6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 19:58:45 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=bx74Hp8RJ4sA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=M0e5Z2DHd9J3UQC3OoEA:9 a=A2gH9t5Y8wIbnEqxTqIA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 2/3] x86, cpu: Clean up and unify the NOP selection
 infrastructure
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
        mingo@elte.hu, Tejun Heo <tj@kernel.org>
In-Reply-To: <4DACCBB0.2060804@linux.intel.com>
References: <1303166160-10315-1-git-send-email-hpa@linux.intel.com>
	 <1303166160-10315-3-git-send-email-hpa@linux.intel.com>
	 <1303169476.7181.71.camel@gandalf.stny.rr.com>
	 <4DACCBB0.2060804@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Apr 2011 19:58:35 -0400
Message-ID: <1303171116.7181.91.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 16:39 -0700, H. Peter Anvin wrote:
> On 04/18/2011 04:31 PM, Steven Rostedt wrote:
> > 
> > Can we please add a comment to this. The original (above) was confusing
> > enough, but at least it used asm() so it wasn't that bad to figure out.
> > Or at least the asm() usage would trigger in one's mind to think "Damn!
> > They chose to use 'asm', it must be some kind of nasty trick. Let's take
> > a better look at WTF they are doing!".
> > 
> > Now the use a normal character array actual makes this even more subtle.
> 
> OK... I never thought it was particularly subtle, but okay.

It took me 2 minutes to figure out what it was doing, but then maybe I'm
slow ;) But having a comment may save a minute or two of frustration
from other reviewers as well.

> 
> A much bigger issue with this particular patch is that the
> __init{data,const}_or_module presumably needs to be removed from these
> structures, right?

Ah, as you have this:


> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -260,9 +260,9 @@ do_ftrace_mod_code(unsigned long ip, void
> *new_code)
>         return mod_code_status;
>  }
>  
> -static unsigned char *ftrace_nop_replace(void)
> +static const unsigned char *ftrace_nop_replace(void)
>  {
> -       return ideal_nop5;
> +       return ideal_nops[NOP_ATOMIC5];
>  }
> 
I would say, yes get rid of the init annotations.

-- Steve


