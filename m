Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab0FQQNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:13:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41491 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759950Ab0FQQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:13:48 -0400
Date: Thu, 17 Jun 2010 09:13:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH] Add TAINT_HARDWARE_UNSUPPORTED flag
Message-Id: <20100617091322.b7d21473.randy.dunlap@oracle.com>
In-Reply-To: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
References: <20100617134654.22523.39845.sendpatchset@prarit.bos.redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4C1A49B0.006C:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 09:54:45 -0400 Prarit Bhargava wrote:

> This patch is similar to Theordore Ts'o's TAINT_USER patch,
> linux-2.6 commit 34f5a39899f3f3e815da64f48ddb72942d86c366.

and augmented by 92946bc72f2e74c3281b7fc12be9704d455fb3ed, so please
add similar info to Documentation/oops-tracing.txt.


> This patch introduces the TAINT_HARDWARE_UNSUPPORTED flag for distributions
> to use.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 8317ec4..f722b0d 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -347,6 +347,7 @@ extern enum system_states {
>  #define TAINT_WARN			9
>  #define TAINT_CRAP			10
>  #define TAINT_FIRMWARE_WORKAROUND	11
> +#define TAINT_HARDWARE_UNSUPPORTED	12
>  
>  extern void dump_stack(void) __cold;
>  
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 3b16cd9..394a5bb 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -180,6 +180,7 @@ static const struct tnt tnts[] = {
>  	{ TAINT_WARN,			'W', ' ' },
>  	{ TAINT_CRAP,			'C', ' ' },
>  	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
> +	{ TAINT_HARDWARE_UNSUPPORTED,	'H', ' ' },
>  };
>  
>  /**
> @@ -197,6 +198,7 @@ static const struct tnt tnts[] = {
>   *  'W' - Taint on warning.
>   *  'C' - modules from drivers/staging are loaded.
>   *  'I' - Working around severe firmware bug.
> + *  'H' - Hardware is unsupported.
>   *
>   *	The string is overwritten by the next call to print_tainted().
>   */
> @@ -243,6 +245,9 @@ void add_taint(unsigned flag)
>  	 */
>  	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
>  		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
> +	if (flag == TAINT_HARDWARE_UNSUPPORTED)
> +		printk(KERN_CRIT "WARNING: This system's hardware is "
> +		       "unsupported.\n");

Preferable not to split the string, so more like:

		printk(KERN_CRIT
			"WARNING: This system's hardware is unsupported.\n");
>  
>  	set_bit(flag, &tainted_mask);
>  }
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
