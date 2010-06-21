Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab0FUNEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:04:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757841Ab0FUNEx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:04:53 -0400
Subject: Re: [PATCH RFC] reduce runqueue lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
       tglx <tglx@linutronix.de>
In-Reply-To: <1277117647.1875.503.camel@laptop>
References: <20100520204810.GA19188@think>
	 <1277114522.1875.469.camel@laptop>  <1277117647.1875.503.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 21 Jun 2010 15:04:39 +0200
Message-ID: <1277125479.1875.510.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 12:54 +0200, Peter Zijlstra wrote:
> > It looses the ttwu task_running() check, as I must admit I'm not quite
> > sure what it does.. Ingo?

I think I figured out what its for, its for when p is prev in schedule()
after deactivate_task(), we have to call activate_task() it again, but
we cannot migrate the task because the CPU its on is still referencing
it.

I added it back, but still fireworks :-)
