Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3AAV1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 16:27:32 -0500
Received: from nm19.access.bullet.mail.sp2.yahoo.com ([98.139.44.146]:27679
	"EHLO nm19.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab3AAV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 16:27:30 -0500
X-Yahoo-Newman-Id: 51267.2181.bm@smtp114.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1KlKIwYVM1leywVN0Bp0Xu6kQdXp_GfOG9uUoXDyZ7ybn8l
 IQv68idN8.MSRhHbSLDQwNicxTHGr.OE5rFiicBrglmFJdHBrNOLptdFzsey
 gKg6WDP2QvVBVsq_0BlUr8kRtNkDSDRv0qO3gz3anl934XAPvGY3IU.0.BR_
 j.YyIW6wsaTkpToTaCbp1rM14i5Vu5W5xsOrYoaYm4NupOQw2671JLEte7W4
 XVv2dLGrbaO7JQhDGNK5rxEYHNRTe4O9k4FsHyGologxiBfyzM_6beWNeY7_
 7iJdaLzJ4aAtEEZxT.jFWEkAFsl1Q776k0bILKH3Q15BvvwiyFBKnwCYf8XO
 VX.lPvQxQUWgNNLmrvDJ.X9Wu5qEmz2P7gHMCxy2DOW_mQ5uZJJMZNHeDl.e
 jdb_y7NSfpeteHCUKRVKa4_VcMfgjthA4NaCgP0D77jz7iI1HNFk43wIx0x7
 _gaBurGRqw7zR0uAgH_uGsLkK
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50E354C2.4060808@att.net>
Date: Tue, 01 Jan 2013 15:27:30 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121128 Thunderbird/10.0.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v7 1/9] compiler-gcc4.h: Reorder macros based upon gcc
 ver
References: <1357074491-21669-1-git-send-email-daniel.santos@pobox.com> <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1357074597-21722-1-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2013 03:09 PM, danielfsantos@att.net wrote:

>   #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
> -#if __GNUC_MINOR__>= 4
> +#if GCC_VERSION>= 40400
>   #define __HAVE_BUILTIN_BSWAP32__
>   #define __HAVE_BUILTIN_BSWAP64__
>   #endif
> -#if __GNUC_MINOR__>= 8 || (defined(__powerpc__)&&  __GNUC_MINOR__>= 6)
> +#if GCC_VERSION>= 40800 || (defined(__powerpc__)&&  GCC_VERSION>= 40600)
>   #define __HAVE_BUILTIN_BSWAP16__
>   #endif
> -#endif
> +#endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP */
I'm terribly sorry, I appear to have broken bisectability here.


