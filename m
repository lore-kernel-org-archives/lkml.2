Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0LPTnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 14:43:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:59472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0LPTnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 14:43:08 -0500
Subject: Re: [RFC][PATCH 0/5] Reduce runqueue lock contention -v2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: frank.rowand@am.sony.com
Cc: frank.rowand@gmail.com, Chris Mason <chris.mason@oracle.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D0A6B03.6080603@am.sony.com>
References: <20101216145602.899838254@chello.nl>
	 <4D0A649B.9080505@am.sony.com> <4D0A6A40.2040907@am.sony.com>
	 <4D0A6B03.6080603@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 16 Dec 2010 20:42:56 +0100
Message-ID: <1292528576.2708.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-16 at 11:39 -0800, Frank Rowand wrote:
>   select_task_rq() uses the smp_processor_id() of the old task_cpu(p) instead
>   of the waking smp_processor_id().

So first you bounce the wakeup to the previous task cpu, when you do
select_task_rq() and then you bounce it to the new target?


