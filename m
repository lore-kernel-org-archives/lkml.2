Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab1GJVIm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 17:08:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54199 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab1GJVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 17:08:40 -0400
Date: Sun, 10 Jul 2011 22:08:33 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do_signal: simplify the TS_RESTORE_SIGMASK logic
Message-ID: <20110710210833.GH11013@ZenIV.linux.org.uk>
References: <20110710182203.GA27979@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110710182203.GA27979@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 08:22:03PM +0200, Oleg Nesterov wrote:

> 2. do_signal() also clears TS_RESTORE_SIGMASK if handle_signal()
>    succeeds.
> 
>    We can move this to setup_rt_frame() as well, this avoids the
>    unnecessary checks and makes the logic more clear.


> +	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
>  	return ret;

This is broken.  If setup_rt_frame() fails, you don't want to do that.
