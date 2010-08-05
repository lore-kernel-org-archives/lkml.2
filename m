Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307Ab0HEM4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:56:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59733 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760297Ab0HEM4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:56:15 -0400
Date: Thu, 5 Aug 2010 18:26:11 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] [BUGFIX] kprobes: Fix selftest to clear flags
 field for reusing probes
Message-ID: <20100805125611.GB28884@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100805123134.3888.4549.stgit@ltc236.sdl.hitachi.co.jp>
 <4C5AAFFF.8060002@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5AAFFF.8060002@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 09:35:11PM +0900, Masami Hiramatsu wrote:
> Fix selftest to clear flags field for reusing probes
> because the flags field can be modified by Kprobes.
> This also set NULL to kprobe.addr instead of 0.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> Cc: linux-kernel@vger.kernel.org
> ---
> 
>  kernel/test_kprobes.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/test_kprobes.c b/kernel/test_kprobes.c
> index 4f10451..f8b11a2 100644
> --- a/kernel/test_kprobes.c
> +++ b/kernel/test_kprobes.c
> @@ -115,7 +115,9 @@ static int test_kprobes(void)
>  	int ret;
>  	struct kprobe *kps[2] = {&kp, &kp2};
> 
> -	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
> +	/* addr and flags should be cleard for reusing kprobe. */
> +	kp.addr = NULL;
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
> +	jp.kp.addr = NULL;
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
> +	rp.kp.addr = NULL;
> +	rp.kp.flags = 0;
>  	ret = register_kretprobes(rps, 2);
>  	if (ret < 0) {
>  		printk(KERN_ERR "Kprobe smoke test failed: "
> 
