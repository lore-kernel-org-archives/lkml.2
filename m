Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab1JLN7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:59:13 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:21270 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750792Ab1JLN7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:59:12 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 9ayf2CcVM1lpjY_WvFyUptnWESH.u.Cm9Qf2_S9jNsW7DmZ
 mgskHee5FCE0XyqDCiU0oMqvocOvIQ8_4bE7N7QF_wCywxebdYUrUH6Nu_BZ
 oIaAnmY6GZkZDz0kv5BQefNVuZWQMsVhHmKkcrW42PKJXdBfIUb676va9G0i
 ejgpNXCEOr0wRzYNcV3U7dr5dgTNwXtOIlgd_I4ObkrSiFTUxJnOvKCNPP8V
 4oZfDncC_F7LKt0QEGMcLIbXqeoOWAyIIxAe0_z_KzgkGi4CImV7uB9PLISW
 3m0Wc0MMgFQ.f1AQlqok5m4yfLbpk6j.JgEwC4Vy4psB1Jt5VtYxdWIJywld
 LV7vcwq95kj6mYiZBbYlkZnIcHPqMLwemZlRCXelpabOETg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 12 Oct 2011 08:59:09 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
In-Reply-To: <1318382964.27949.782.camel@debian>
Message-ID: <alpine.DEB.2.00.1110120857310.26026@router.home>
References: <1318237851.27949.190.camel@debian>  <alpine.DEB.2.00.1110101026080.16264@router.home>  <1318324774.27949.693.camel@debian>  <alpine.DEB.2.00.1110110910480.3388@router.home> <1318382964.27949.782.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Alex,Shi wrote:

>  #ifdef CONFIG_SMP
>  #define __percpu_prefix                "%%"__stringify(__percpu_seg)":"
> -#define __my_cpu_offset                percpu_read(this_cpu_off)
> +#define __my_cpu_offset                __this_cpu_read(this_cpu_off)
>
> I do not quite understand you here. Do you mean to change every possible
> this_cpu_xxx() to __this_cpu_xxx()?

Change only those locations where the kernel thread cannot be preempted.


