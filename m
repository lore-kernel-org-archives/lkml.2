Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab0C0E4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 00:56:14 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:62747 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0C0E4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 00:56:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wFqKgkBQMtUcVOC0VF2Ji0+Xlwgr05EZDxrkacNYD8i8CSEspXiRsseSlc+aokUr/B
         RUBxa/fGa1BrBU6c0BdWaoqj3jBlf6p4JE/kVRjEZ3pixfzwTA7fEvqAa8po9U6esmAf
         ovPEaZ/9XWMMoaJQFVMYSBKfQZH0MdRS3KTE8=
Date: Sat, 27 Mar 2010 05:56:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 07/14 re-post] syscalls: add
	ARCH_COMPAT_SYSCALL_DEFINE()
Message-ID: <20100327045608.GP7166@nowhere>
References: <cover.1268749695.git.jbaron@redhat.com> <cbd14095e98f80fd05d3e8e76111572072e565bc.1268749695.git.jbaron@redhat.com> <20100318182909.GB2661@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318182909.GB2661@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 02:29:09PM -0400, Jason Baron wrote:
> 
> Re-post due to missing macro parameter. interdiff:
> 
> diff -u b/include/linux/syscalls.h b/include/linux/syscalls.h
> --- b/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -241,7 +241,7 @@
>  	SYSCALL_METADATA(syscall, compat_sys_##sname, x);	\
>  	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
>  #else
> -#define COMPAT_SYSCALL_DEFINEx(x, sname, ...)			\
> +#define COMPAT_SYSCALL_DEFINEx(x, syscall, sname, ...)		\
>  	asmlinkage long syscall(__SC_DECL##x(__VA_ARGS__))
>  #endif
> 
> --------------------------------------------------------
> 
> Add ARCH_COMPAT_SYSCALL_DEFINE#N() macro which prepends "sys32_" to
> arch specific compat syscall names. Identifies the 'compat' syscalls.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/linux/syscalls.h |   50 ++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 38 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index e601985..b5f66dc 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -141,7 +141,7 @@ struct perf_event_attr;
>  	  __attribute__((__aligned__(4)))				\
>  	  __attribute__((section("_ftrace_events")))			\
>  	  event_enter_##sname = {					\
> -		.name                   = "sys_enter"#sname,		\
> +		.name                   = "enter_"#sname,		\



BTW, removing the sys_ prefix would be a cool change but I'd prefer
we limit the ABI changes if possible (although I must confess
the ABI is going to be seriously damaged if we support user pointer
deref later :p)

Thanks.

