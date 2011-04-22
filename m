Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab1DVNpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:45:46 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43132 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755505Ab1DVNpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:45:45 -0400
Date: Fri, 22 Apr 2011 14:45:43 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/7] x86: signal: handle_signal() should use
 set_current_blocked()
Message-ID: <20110422144543.60c65c8e@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110418134615.GG15951@redhat.com>
References: <20110418134421.GA15951@redhat.com>
	<20110418134615.GG15951@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 15:46:15 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> This is ugly, but if sigprocmask() needs retarget_shared_pending() then
> handle signal should follow this logic. In theory it is newer correct to
							   ^^ never ;-)

> add the new signals to current->blocked, the signal handler can sleep/etc
> so we should notify other threads in case we block the pending signal and
> nobody else has TIF_SIGPENDING.
> 
> Of course, this change doesn't make signals faster :/
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
