Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933199Ab0JRTw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:52:29 -0400
Received: from relay2.sgi.com ([192.48.179.30]:45596 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933146Ab0JRTw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:52:28 -0400
Date: Mon, 18 Oct 2010 14:52:27 -0500
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] Incoming XPC channel messages can come in after the
 channel's partition structures have been torn down.
Message-ID: <20101018195227.GK14064@sgi.com>
References: <20101018133508.GC14064@sgi.com>
 <20101018124055.26325ea5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018124055.26325ea5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:40:55PM -0700, Andrew Morton wrote:
> On Mon, 18 Oct 2010 08:35:08 -0500
> Robin Holt <holt@sgi.com> wrote:
> 
> > Under some workloads, some channel messages have been observed being
> > delayed on the sending side past the point where the receiving side
> > has been able to tear down its partition structures.  This condition is
> > already detected in xpc_handle_activate_IRQ_uv(), but that information
> > is not given to xpc_handle_activate_mq_msg_uv().  As a result,
> > xpc_handle_activate_mq_msg_uv() assumes the structures still exist and
> > references them.
> 
> With what result?  Machine goes boom?
> 
> Would you consider this a 2.6.36 fix?  Backport to -stable?

I would consider it a backport to stable.  It is a NULL pointer deref.
This pach applies back to 2.6.32.  I did not try older kernels than
that.

Robin
