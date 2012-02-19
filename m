Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2BSPVd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 10:21:33 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57432 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2BSPVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 10:21:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of xiyou.wangcong@gmail.com designates 10.68.236.136 as permitted sender) smtp.mail=xiyou.wangcong@gmail.com; dkim=pass header.i=xiyou.wangcong@gmail.com
Message-ID: <4F411373.50304@gmail.com>
Date: Sun, 19 Feb 2012 23:21:23 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Tao Jiang <jiangtao.jit@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: A problem with percpu variable cpu_number
References: <CAOe6JY2fQ7UcnVprer9tXPxz0FDEv5h1j6txP576-EKXc9v5PA@mail.gmail.com> <CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com>
In-Reply-To: <CAOe6JY2W8H2FMbMUsUp=72gH6y_SXPvjwZ0fqOwXWUdknr=7yQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 08:20 PM, Tao Jiang wrote:
> Hi :
>
> At the beginning of start_kernel() -- init/main.c
> boot_cpu_init() is called
>
> and in boot_cpu_init() will call smp_processor_id()
> it's a macro
> and it will be expanded as (percpu_read(cpu_number)) and so on
>
> but i noticed that it's before setup_per_cpu_areas() in start_kernel()
> is that mean the percpu areas hadn't be initialized yet
> but why smp_processor_id() could be called before setup_per_cpu_areas()

It doesn't matter, as the percpu var 'cpu_number' is defined statically: 
DECLARE_PER_CPU(int, cpu_number);.

Thanks.
