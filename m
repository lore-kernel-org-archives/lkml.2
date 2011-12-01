Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1LACMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:12:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289Ab1LACMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:12:08 -0500
Date: Wed, 30 Nov 2011 18:13:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-Id: <20111130181318.38f4659d.akpm@linux-foundation.org>
In-Reply-To: <20111201020727.GB30097@sgi.com>
References: <20111108191149.GA7236@sgi.com>
	<20111122160802.e99d6218.akpm@linux-foundation.org>
	<20111130152959.GA19205@sgi.com>
	<20111130161131.31cdccff.akpm@linux-foundation.org>
	<20111130161610.69c516f7.akpm@linux-foundation.org>
	<20111201020727.GB30097@sgi.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Nov 2011 20:07:27 -0600 Dimitri Sivanich <sivanich@sgi.com> wrote:

> > And the whole thing is racy, isn't it?  The "new" CPU can go offline a
> > nanosecond after we performed that test, so why perform it at all?
> 
> See my email concerning the panic in cpu_online().

That doesn't address my question.

What's the point in checking cpu_online() when we have no locks to
prevent the online map from changing?

What happens if this cpu goes offline immediately after that check has
passed?

