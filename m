Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0G0XhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:37:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164Ab0G0XhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:37:23 -0400
Date: Tue, 27 Jul 2010 16:36:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] sysrq: don't hold the sysrq_key_table_lock during
 the handler
Message-Id: <20100727163622.a19a827b.akpm@linux-foundation.org>
In-Reply-To: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
References: <1280138042-1576-1-git-send-email-dfeng@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jul 2010 17:54:02 +0800
Xiaotian Feng <dfeng@redhat.com> wrote:

> sysrq_key_table_lock is used to protect the sysrq_key_table, make sure
> we get/replace the right operation for the sysrq. But in __handle_sysrq,
> kernel will hold this lock and disable irqs until we finished op_p->handler().
> This may cause false positive watchdog alert when we're doing "show-task-states"
> on a system with many tasks.
> 

It would be better to find a suitable point in an inner loop and add an
appropriately-commented touch_nmi_watchdog().

That way the problem gets fixed for all irqs-off callers, not just one
of them.

