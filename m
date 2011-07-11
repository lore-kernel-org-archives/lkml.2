Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1GKLlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 07:41:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab1GKLlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 07:41:42 -0400
Date: Mon, 11 Jul 2011 13:39:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do_signal: simplify the TS_RESTORE_SIGMASK logic
Message-ID: <20110711113914.GA4404@redhat.com>
References: <20110710182203.GA27979@redhat.com> <20110710210833.GH11013@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110710210833.GH11013@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10, Al Viro wrote:
>
> On Sun, Jul 10, 2011 at 08:22:03PM +0200, Oleg Nesterov wrote:
>
> > 2. do_signal() also clears TS_RESTORE_SIGMASK if handle_signal()
> >    succeeds.
> >
> >    We can move this to setup_rt_frame() as well, this avoids the
> >    unnecessary checks and makes the logic more clear.
>
>
> > +	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
> >  	return ret;
>
> This is broken.

You know, I was also going to change this "return ret", "return 0"
looks more clear to me. But then I should have renamed "ret", and
I decided to leave  it alone.

> If setup_rt_frame() fails, you don't want to do that.

Sure. Please look at the code, it does

	if (ret) {
		force_sigsegv(sig, current);
		return -EFAULT;
	}

	current_thread_info()->status &= ~TS_RESTORE_SIGMASK;
	return ret;

We clear TS_RESTORE_SIGMASK only if we return 0.

Oleg.

