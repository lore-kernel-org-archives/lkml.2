Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab0ESFC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:02:56 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58460 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab0ESFCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:02:55 -0400
Date: Wed, 19 May 2010 10:32:46 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH -tip v2 1/5] [BUGFIX] kprobes: Fix selftest to clear
	flags field for reusing probes
Message-ID: <20100519050246.GB17114@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100518201244.6058.73083.stgit@localhost6.localdomain6> <20100518201251.6058.60749.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100518201251.6058.60749.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:12:51PM -0400, Masami Hiramatsu wrote:
 
>  kernel/test_kprobes.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
> index 4f10451..ede20f4 100644
> --- a/kernel/test_kprobes.c
> +++ b/kernel/test_kprobes.c
> @@ -115,7 +115,9 @@ static int test_kprobes(void)
>  	int ret;
>  	struct kprobe *kps[2] = {&kp, &kp2};
> 
> -	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
> +	/* addr and flags should be cleard for reusing kprobe. */
> +	kp.addr = 0;

kp.addr = NULL;

> +	kp.flags = 0;
>  	ret = register_kprobes(kps, 2);
>  	if (ret < 0) {
>  		printk(KERN_ERR "Kprobe smoke test failed: "
> @@ -210,7 +212,9 @@ static int test_jprobes(void)
>  	int ret;
>  	struct jprobe *jps[2] = {&jp, &jp2};
> 
> -	jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
> +	/* addr and flags should be cleard for reusing kprobe. */
> +	jp.kp.addr = 0;

Same here...

> +	jp.kp.flags = 0;
>  	ret = register_jprobes(jps, 2);
>  	if (ret < 0) {
>  		printk(KERN_ERR "Kprobe smoke test failed: "
> @@ -323,7 +327,9 @@ static int test_kretprobes(void)
>  	int ret;
>  	struct kretprobe *rps[2] = {&rp, &rp2};
> 
> -	rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
> +	/* addr and flags should be cleard for reusing kprobe. */
> +	rp.kp.addr = 0;

Here too.

Ananth
