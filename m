Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab0FGKLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 06:11:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab0FGKLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 06:11:18 -0400
Message-ID: <4C0CC5C3.6000702@suse.cz>
Date: Mon, 07 Jun 2010 12:11:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, "David S. Miller" <davem@davemloft.net>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] perf tools: Make target to generate self contained
 source tarball
References: <20100528185357.GA28009@ghostprotocols.net> <20100529072948.GE16257@merkur.ravnborg.org> <20100531174207.GB3481@ghostprotocols.net> <4C0417EC.8050906@suse.cz> <20100531230639.GD3481@ghostprotocols.net> <4C04E0EA.8010100@suse.cz> <20100604173552.GA875@ghostprotocols.net>
In-Reply-To: <20100604173552.GA875@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.6.2010 19:35, Arnaldo Carvalho de Melo wrote:
> Em Tue, Jun 01, 2010 at 12:28:58PM +0200, Michal Marek escreveu:
>> On 1.6.2010 01:06, Arnaldo Carvalho de Melo wrote:
>>> Well, what about the other aspects of the patch, is this the only issue
>>> you have found with it?
>>
>> The patch is OK.
>>
>> Acked-by: Michal Marek <mmarek@suse.cz>
> 
> Argh, there was one last detail, so that we don't require that the
> kernel be configured first, and as we don't use KERNELRELEASE at all in
> the -src-pkg targets, would that be OK with you too?
> 
> [acme@emilia linux-2.6-tip]$ git diff Makefile 
> diff --git a/Makefile b/Makefile
> index 0ab0c6f..6e186a1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1215,6 +1215,8 @@ distclean: mrproper
>  # rpm target kept for backward compatibility
>  package-dir    := $(srctree)/scripts/package
>  
> +%src-pkg: FORCE
> +       $(Q)$(MAKE) $(build)=$(package-dir) $@
>  %pkg: include/config/kernel.release FORCE
>         $(Q)$(MAKE) $(build)=$(package-dir) $@
>  rpm: include/config/kernel.release FORCE
> [acme@emilia linux-2.6-tip]$
> 
> On a make mrproper'ed kernel we get:
> 
> a linux-2.6-tip]$ LANG= make perf-tarbz2-src-pkg
> /bin/sh: include/config/kernel.release: No such file or directory
> make: *** [include/config/kernel.release] Error 1
> [acme@emilia linux-2.6-tip]$
> 
> :-\
> 
> If you're ok with it, I'll add it as a follow on patch that I'll send
> via Ingo.

Looks ok to me, any future *-src-pkg target will also just package
sources and thus not depend on the configuration.

Acked-by: Michal Marek <mmarek@suse.cz>

Michal
