Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab0JUGLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 02:11:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59640 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0JUGLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 02:11:01 -0400
Message-ID: <4CBFD963.8060005@zytor.com>
Date: Wed, 20 Oct 2010 23:10:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, tglx@linutronix.de, shaohua.li@intel.com,
        hpa@linux.intel.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] percpu: Introduce a read-mostly percpu API
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com> <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
In-Reply-To: <tip-c957ef2c59e952803766ddc22e89981ab534606f@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 04:06 PM, tip-bot for Shaohua Li wrote:

> 
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 8a92a17..d7e7b21 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -677,7 +677,9 @@
>  				- LOAD_OFFSET) {			\
>  		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
>  		*(.data..percpu..first)					\
> +		. = ALIGN(PAGE_SIZE);					\
>  		*(.data..percpu..page_aligned)				\
> +		*(.data..percpu..readmostly)				\
>  		*(.data..percpu)					\
>  		*(.data..percpu..shared_aligned)			\
>  		VMLINUX_SYMBOL(__per_cpu_end) = .;			\
> @@ -703,6 +705,8 @@
>  		VMLINUX_SYMBOL(__per_cpu_load) = .;			\
>  		VMLINUX_SYMBOL(__per_cpu_start) = .;			\
>  		*(.data..percpu..first)					\
> +		. = ALIGN(PAGE_SIZE);					\
> +		*(.data..percpu..readmostly)				\
>  		*(.data..percpu..page_aligned)				\
>  		*(.data..percpu)					\
>  		*(.data..percpu..shared_aligned)			\

ARGH... looks like I didn't catch it everywhere...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

