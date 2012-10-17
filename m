Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab2JQCCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 22:02:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50800 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab2JQCCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 22:02:37 -0400
MIME-Version: 1.0
In-Reply-To: <1350468706.15558.26.camel@cliu38-desktop-build>
References: <1350468706.15558.26.camel@cliu38-desktop-build>
Date: Tue, 16 Oct 2012 19:02:35 -0700
X-Google-Sender-Auth: zjuZ-yeEFkQ0-rPr3aVF7yf8-jk
Message-ID: <CAE9FiQXFvuWS3HPBefUDS+a8VT_2=xtbjFowoPqZcwJSoKt_Hg@mail.gmail.com>
Subject: Re: [PATCH] x86/ioapic: fix the irq_2_pin mem leak when destroy_irq
From: Yinghai Lu <yinghai@kernel.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, suresh.b.siddha@intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 3:11 AM, Chuansheng Liu
<chuansheng.liu@intel.com> wrote:
>
> When destroying the irq, before free cfg, need to check
> cfg->irq_2_pin and free it when it is not NULL.
>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---

i had that in another patch...

https://lkml.org/lkml/2012/2/23/574

----
Subject	[PATCH 01/13] x86, irq: Convert irq_2_pin list to generic list
Date	Thu, 23 Feb 2012 19:48:47 -0800

So we can use generic list helper function.

Also make free_irq_cfg() free irq_2_pin list.
----

http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=commitdiff;h=4010f4dbd1b172e3080d3e6c459a58c4b575f081

Yinghai
