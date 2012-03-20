Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab2CTUqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:46:11 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60759 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754353Ab2CTUqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:46:09 -0400
Message-ID: <4F68EC88.7080607@xenotime.net>
Date: Tue, 20 Mar 2012 13:46:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Documentation/CodingStyle: Add guidelines for inline
 assembly
References: <20120202223304.GA13069@leaf>
In-Reply-To: <20120202223304.GA13069@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 02:33 PM, Josh Triplett wrote:

> Signed-off-by: Josh Triplett <josh@joshtriplett.org>



Applied.  Thanks.


> ---
>  Documentation/CodingStyle |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 2b90d32..c58b236 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -793,6 +793,35 @@ own custom mode, or may have some other magic method for making indentation
>  work correctly.
>  
>  
> +		Chapter 19:  Inline assembly
> +
> +In architecture-specific code, you may need to use inline assembly to interface
> +with CPU or platform functionality.  Don't hesitate to do so when necessary.
> +However, don't use inline assembly gratuitously when C can do the job.  You can
> +and should poke hardware from C when possible.
> +
> +Consider writing simple helper functions that wrap common bits of inline
> +assembly, rather than repeatedly writing them with slight variations.  Remember
> +that inline assembly can use C parameters.
> +
> +Large, non-trivial assembly functions should go in .S files, with corresponding
> +C prototypes defined in C header files.  The C prototypes for assembly
> +functions should use "asmlinkage".
> +
> +You may need to mark your asm statement as volatile, to prevent GCC from
> +removing it if GCC doesn't notice any side effects.  You don't always need to
> +do so, though, and doing so unnecessarily can limit optimization.
> +
> +When writing a single inline assembly statement containing multiple
> +instructions, put each instruction on a separate line in a separate quoted
> +string, and end each string except the last with \n\t to properly indent the
> +next instruction in the assembly output:
> +
> +	asm ("magic %reg1, #42\n\t"
> +	     "more_magic %reg2, %reg3"
> +	     : /* outputs */ : /* inputs */ : /* clobbers */);
> +
> +
>  
>  		Appendix I: References
>  



-- 
~Randy
