Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1DVPTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 11:19:19 -0400
Received: from bitwagon.com ([74.82.39.175]:55216 "HELO bitwagon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755905Ab1DVPTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 11:19:18 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Apr 2011 11:19:18 EDT
Message-ID: <4DB19A1E.8070806@bitwagon.com>
Date: Fri, 22 Apr 2011 08:09:18 -0700
From: John Reiser <jreiser@bitwagon.com>
Organization: -
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC][PATCH 01/11] ftrace/trivial: Clean up recordmcount.c to
 use Linux style comparisons
References: <20110421022825.535486725@goodmis.org> <20110421023737.290712238@goodmis.org>
In-Reply-To: <20110421023737.290712238@goodmis.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 07:28 PM, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The Linux style for comparing is:
> 
>   var == 1
>   var > 0
> 
> and not:
> 
>   1 == var
>   0 < var
> 
> It is considered that Linux developers are smart enough not to do the
> 
>   if (var = 1)
> 
> mistake.

It's not just a matter of 'smart', it's a matter of safety.
For me it still catches a bug (typo, copy+paste, fumble in editor script, ...)
every year or two.  Compilers haven't always warned, or the option to warn
might be turned off.

> -	return 0 == strcmp(".text",           txtname) ||
> +	return strcmp(".text",           txtname) == 0 ||

I consider "0==strcmp(" to be an idiom.  Too often "strcmp(...) == 0"
overflows my mental stack because of the typographic width of the operands
in the source code.  If you still object in this case then please consider
using something like:
	#define strequ(a,b) (strcmp((a), (b)) == 0)
or
	static int strequ(char const *a, char const *b)
	{
		return strcmp(a, b) == 0;
	}
which names the idiom.

-- 
John Reiser
