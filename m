Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2JPLz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:55:26 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:55795 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2JPLzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:55:25 -0400
X-AuditID: b753bd60-8f6bfba0000047ca-6b-507d4b2b31cc
X-AuditID: b753bd60-8f6bfba0000047ca-6b-507d4b2b31cc
Message-ID: <507D4B2A.6080107@hitachi.com>
Date: Tue, 16 Oct 2012 20:55:22 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hyeoncheol Lee <hyc.lee@gmail.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [PATCH] uprobes tracer: Add stack/memory/retval access support
References: <1350378135-18919-1-git-send-email-hyc.lee@gmail.com>
In-Reply-To: <1350378135-18919-1-git-send-email-hyc.lee@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/10/16 18:02), Hyeoncheol Lee wrote:
> Event arguments except @SYM are supported. They are @ADDR,
> $stack, $stackN, $retval, and offs(arguments).
> 
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
> ---

[...]
>  #define DEFINE_FETCH_stack(type)					\
>  static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
> -					  void *offset, void *dest)	\
> +					  void *offset, void *dest,	\
> +					  bool kprobe)			\
>  {									\
> -	*(type *)dest = (type)regs_get_kernel_stack_nth(regs,		\
> +	if (kprobe)							\
> +		*(type *)dest = (type)regs_get_kernel_stack_nth(regs,	\
>  				(unsigned int)((unsigned long)offset));	\
> +	else								\
> +		*(type *)dest = (type)regs_get_user_stack_nth(regs,	\
> +				(unsigned int)((unsigned long)offset)); \
>  }


Hmm, I don't think this is a good way to do that.
If fetching user space objects is different from the kernel one,
we'd better introduce new fetch handlers for it, instead of checking
a bool flag every time, because it will be done on every events.

Thank you,


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


