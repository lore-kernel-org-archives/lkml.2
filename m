Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779Ab2EITHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:07:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760282Ab2EITHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:07:47 -0400
Date: Wed, 9 May 2012 12:07:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
Message-Id: <20120509120745.042e86c6.akpm@linux-foundation.org>
In-Reply-To: <1336570043.2527.38.camel@twins>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	<4FAA452A.1070909@gmail.com>
	<4FAA588B.5010404@redhat.com>
	<1336564330.2527.23.camel@twins>
	<4FAA5BFB.40309@redhat.com>
	<1336566096.2527.30.camel@twins>
	<1336566644.2527.33.camel@twins>
	<1336570043.2527.38.camel@twins>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2012 15:27:23 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> + * - 'b' For a bitmap, consumes 2 args, second is int

There's a pretty widespread convention that %b is used to print in
binary: printf("%b", 10) -> 1010.  Regrettably it isn't part of
standard C, but it's often supported anyway.  Perl's printf does this
as well.  Perl uses %B also.

If we later want to add binary printing to kernel print(), we'd presumably
use %pb, to match this precedent.

So perhaps it would be better to avoid consuming `b' for bitmaps?
