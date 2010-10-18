Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182Ab0JRTl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:41:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41050 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933159Ab0JRTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:41:25 -0400
Date: Mon, 18 Oct 2010 12:40:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Incoming XPC channel messages can come in after the
 channel's partition structures have been torn down.
Message-Id: <20101018124055.26325ea5.akpm@linux-foundation.org>
In-Reply-To: <20101018133508.GC14064@sgi.com>
References: <20101018133508.GC14064@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 08:35:08 -0500
Robin Holt <holt@sgi.com> wrote:

> Under some workloads, some channel messages have been observed being
> delayed on the sending side past the point where the receiving side
> has been able to tear down its partition structures.  This condition is
> already detected in xpc_handle_activate_IRQ_uv(), but that information
> is not given to xpc_handle_activate_mq_msg_uv().  As a result,
> xpc_handle_activate_mq_msg_uv() assumes the structures still exist and
> references them.

With what result?  Machine goes boom?

Would you consider this a 2.6.36 fix?  Backport to -stable?
