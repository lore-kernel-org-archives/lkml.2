Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1LLQsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 11:48:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:49397 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1LLQsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 11:48:04 -0500
Message-ID: <1323708439.21400.6.camel@twins>
Subject: Re: [PATCH -rt] printk: Disable migration instead of preemption
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Weinberger <rw@linutronix.de>, linux-kernel@vger.kernel.org
Date: Mon, 12 Dec 2011 17:47:19 +0100
In-Reply-To: <alpine.LFD.2.02.1112121734580.3020@ionos>
References: <1323696956-11445-1-git-send-email-rw@linutronix.de>
	 <1323703531.21400.1.camel@twins> <alpine.LFD.2.02.1112121734580.3020@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-12 at 17:35 +0100, Thomas Gleixner wrote:
> 
> The point is that we drop that lock further down and on RT we also
> reenable interrupts, so we have to prevent that we get migrated away.
> 
Oh ok. I missed -rt reenabling interrupts somewhere down there.

Do note that these preempt_disable/enable calls are gone upstream.
