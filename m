Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0IYD0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 23:26:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53206 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0IYD0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 23:26:41 -0400
Date: Sat, 25 Sep 2010 04:26:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] signal: annotate siglock acquisition
Message-ID: <20100925032638.GT19804@ZenIV.linux.org.uk>
References: <1285384856-4310-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285384856-4310-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 12:20:56PM +0900, Namhyung Kim wrote:
> lock_task_sighand() conditionally acquires sighand->siglock in case of
> returning non-NULL but unlock_task_sighand() releases it unconditionally.
> This leads sparse to complain about the lock context imbalance. Annotate it
> to make sparse happier.

That's not a good way to do it; use __cond_lock instead.
