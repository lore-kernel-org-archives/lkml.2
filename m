Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab0CXUVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:21:50 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:55504 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756620Ab0CXUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:21:49 -0400
Message-ID: <4BAA743E.6080205@oracle.com>
Date: Wed, 24 Mar 2010 13:21:18 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 2.6.33 GP fault only when built with tracing
References: <4BA2B69D.3000309@oracle.com> <1268956555.758.18.camel@gandalf.stny.rr.com> <20100319005901.GB23020@Krystal> <4BA3C0CF.6070005@oracle.com> <20100319184610.GA29161@Krystal> <20100323082643.dbf77c46.randy.dunlap@oracle.com> <20100324012053.GA17187@Krystal>
In-Reply-To: <20100324012053.GA17187@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BAA7449.024E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/10 18:20, Mathieu Desnoyers wrote:
> 
> While we wait for the sun to move to other time zones, can you check if the
> following patch fixes your problem ?
> 

Hi Mathieu,
Yes, this works.  Thanks.

I'll test Li's patch now...

> 
> module: fix __module_ref_addr()
> 
> __module_ref_addr() should use per_cpu_ptr() to obfuscate the pointer
> (RELOC_HIDE is needed for per cpu pointers).
> 
> This non-standard per-cpu pointer use has been introduced by commit
> 720eba31f47aeade8ec130ca7f4353223c49170f
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Eric Dumazet <dada1@cosmosbay.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/module.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-lttng/include/linux/module.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/module.h	2010-03-23 18:11:14.000000000 -0400
> +++ linux-2.6-lttng/include/linux/module.h	2010-03-23 18:14:07.000000000 -0400
> @@ -467,7 +467,7 @@ void symbol_put_addr(void *addr);
>  static inline local_t *__module_ref_addr(struct module *mod, int cpu)
>  {
>  #ifdef CONFIG_SMP
> -	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
> +	return (local_t *) per_cpu_ptr(mod->refptr, cpu);
>  #else
>  	return &mod->ref;
>  #endif


-- 
~Randy
