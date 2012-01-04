Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2ADMal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:30:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:38784 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab2ADMai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:30:38 -0500
Message-ID: <1325680229.2697.2.camel@twins>
Subject: Re: [PATCH]sched: stop hrtick timer if running task is switching
 from fair scheduling class to another
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <kirill.tkhai@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Kirill Tkhai <tkhai@yandex.ru>
Date: Wed, 04 Jan 2012 13:30:29 +0100
In-Reply-To: <20111226154257.GA21445@redhat.com>
References: <1324584060.4222.15.camel@hp>
	 <20111226154257.GA21445@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-12-26 at 16:42 +0100, Oleg Nesterov wrote:
> 
> Peter, Ingo, does this code really work? SCHED_FEAT(HRTICK) == 0
> by default, and afaics you can't change it without CONFIG_SCHED_DEBUG.
> 
> 

No its broken. Maybe I should've removed it, but I've always been
meaning to fix it since SCHED_DEADLINE actually needs it, but alas.
-ENOTIME and no urgency need have conspired against it.
