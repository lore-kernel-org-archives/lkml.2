Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720Ab2GCSMr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:12:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61616 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2GCSMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:12:10 -0400
MIME-Version: 1.0
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A10AFDE@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A109B17@SHSMSX101.ccr.corp.intel.com>
 <CAPXgP10pQWHYmi1egdArnbnmq=ATDbVo3GBG-=vHskrgkCH1xA@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A10AFDE@SHSMSX101.ccr.corp.intel.com>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 3 Jul 2012 20:11:48 +0200
Message-ID: <CAPXgP10JJ3c3T7V5AV-tQyroCe01HgQUZ0F5LsoOwFTgZz5M9w@mail.gmail.com>
Subject: Re: [PATCH] printk: replacing the raw_spin_lock/unlock with raw_spin_lock_irqsave/irqrestore
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 12:01 AM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
> Thanks your pointing out. New patch as below:
>
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] printk: replacing the raw_spin_lock/unlock with raw_spin_lock/unlock_irq
>
> In function devkmsg_read/writev/llseek/poll/open()..., the function
> raw_spin_lock/unlock is used, there is potential deadlock case happening.
> CPU1: thread1 doing the cat /dev/kmsg:
>         raw_spin_lock(&logbuf_lock);
>         while (user->seq == log_next_seq) {
> when thread1 run here, at this time one interrupt is coming on CPU1 and running
> based on this thread,if the interrupt handle called the printk which need the
> logbuf_lock spin also, it will cause deadlock.
>
> So we should use raw_spin_lock/unlock_irq here.
>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>

Acked-By: Kay Sievers <kay@vrfy.org>

Kay
