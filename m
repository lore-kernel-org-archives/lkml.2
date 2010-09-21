Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab0IUBSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 21:18:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55804 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325Ab0IUBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 21:18:00 -0400
Date: Mon, 20 Sep 2010 18:25:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] MEMSTICK: add support for legacy memorysticks
Message-Id: <20100920182537.9e0920ad.akpm@linux-foundation.org>
In-Reply-To: <553730.24538.qm@web37605.mail.mud.yahoo.com>
References: <20100920120235.f7b93405.akpm@linux-foundation.org>
	<553730.24538.qm@web37605.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010 18:16:03 -0700 (PDT) Alex Dubov <oakad@yahoo.com> wrote:

> However, do you have a quick
> advice for a case, were idr_pre_get happens outside spin-locked section,
> as opposed to mutex one?

It sucks, but...

again:
	if (idr_pre_get(..., GFP_KERNEL) == NULL)
		return -ENOMEM;		/* We're really out-of-memory */
	spin_lock(lock);
	if (idr_get_new(...) == -EAGAIN) {
		spin_unlock(lock);
		goto again;		/* Someone stole our preallocation! */
	}
