Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0DVK1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:27:36 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:35298 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0DVK1e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:27:34 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest os statistics from host side
Date: Thu, 22 Apr 2010 18:27:13 +0800
Message-ID: <0A1FE637C2C7E148B9573BB60CC630E5905A23@zch01exm26.fsl.freescale.net>
In-Reply-To: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH V5 1/3] perf & kvm: Enhance perf to collect KVM guest os statistics from host side
Thread-Index: AcrfgiFylynjZUOtS/y4Q5vQNfft+ACgB/VQ
References: <1271655161.2078.603.camel@ymzhang.sh.intel.com>
From: "Liu Yu-B13201" <B13201@freescale.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       "Avi Kivity" <avi@redhat.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Avi Kivity" <avi@redhat.com>, "Sheng Yang" <sheng@linux.intel.com>,
       <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       "Marcelo Tosatti" <mtosatti@redhat.com>,
       "oerg Roedel" <joro@8bytes.org>,
       "Jes Sorensen" <Jes.Sorensen@redhat.com>,
       "Gleb Natapov" <gleb@redhat.com>, "Zachary Amsden" <zamsden@redhat.com>,
       <zhiteng.huang@intel.com>, <tim.c.chen@intel.com>,
       "Arnaldo Carvalho de Melo" <acme@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: kvm-owner@vger.kernel.org 
> [mailto:kvm-owner@vger.kernel.org] On Behalf Of Zhang, Yanmin
> Sent: Monday, April 19, 2010 1:33 PM
> To: Avi Kivity
> Cc: Ingo Molnar; Peter Zijlstra; Avi Kivity; Sheng Yang; 
> linux-kernel@vger.kernel.org; kvm@vger.kernel.org; Marcelo 
> Tosatti; oerg Roedel; Jes Sorensen; Gleb Natapov; Zachary 
> Amsden; zhiteng.huang@intel.com; tim.c.chen@intel.com; 
> Arnaldo Carvalho de Melo
> Subject: [PATCH V5 1/3] perf & kvm: Enhance perf to collect 
> KVM guest os statistics from host side
> 
> Below patch introduces perf_guest_info_callbacks and related 
> register/unregister
> functions. Add more PERF_RECORD_MISC_XXX bits meaning guest 
> kernel and guest user
> space.
> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> 
> ---

> diff -Nraup --exclude-from=exclude.diff 
> linux-2.6_tip0417/include/linux/perf_event.h 
> linux-2.6_tip0417_perfkvm/include/linux/perf_event.h
> --- linux-2.6_tip0417/include/linux/perf_event.h	
> 2010-04-19 09:51:59.544791000 +0800
> +++ linux-2.6_tip0417_perfkvm/include/linux/perf_event.h	
> 2010-04-19 09:53:59.691378953 +0800

> @@ -932,6 +940,12 @@ static inline void perf_event_mmap(struc
>  		__perf_event_mmap(vma);
>  }
>  
> +extern struct perf_guest_info_callbacks *perf_guest_cbs;
> +extern int perf_register_guest_info_callbacks(
> +		struct perf_guest_info_callbacks *);
> +extern int perf_unregister_guest_info_callbacks(
> +		struct perf_guest_info_callbacks *);
> +
>  extern void perf_event_comm(struct task_struct *tsk);
>  extern void perf_event_fork(struct task_struct *tsk);
>  
> @@ -1001,6 +1015,11 @@ perf_sw_event(u32 event_id, u64 nr, int 
>  static inline void
>  perf_bp_event(struct perf_event *event, void *data)		
> 	{ }
>  
> +static inline int perf_register_guest_info_callbacks
> +(struct perf_guest_info_callbacks *) {return 0; }
> +static inline int perf_unregister_guest_info_callbacks
> +(struct perf_guest_info_callbacks *) {return 0; }
> +
>  static inline void perf_event_mmap(struct vm_area_struct 
> *vma)		{ }
>  static inline void perf_event_comm(struct task_struct *tsk)	
> 	{ }
>  static inline void perf_event_fork(struct task_struct *tsk)	
> 	{ }


Hi,

I met this error when built kernel. Anything wrong?

  CC      init/main.o
In file included from include/linux/ftrace_event.h:8,
                 from include/trace/syscall.h:6,
                 from include/linux/syscalls.h:75,
                 from init/main.c:16:
include/linux/perf_event.h: In function 'perf_register_guest_info_callbacks':
include/linux/perf_event.h:1019: error: parameter name omitted
include/linux/perf_event.h: In function 'perf_unregister_guest_info_callbacks':
include/linux/perf_event.h:1021: error: parameter name omitted
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2

