Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1IZReT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 13:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529Ab1IZReS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:34:18 -0400
Date: Mon, 26 Sep 2011 19:07:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <htejun@gmail.com>, Luke Macken <lmacken@redhat.com>,
        stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-3.0] ptrace: don't clear GROUP_STOP_SIGMASK on
	double-stop
Message-ID: <20110926170744.GA16944@redhat.com>
References: <20110926170632.GA16936@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110926170632.GA16936@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26, Oleg Nesterov wrote:
>
> 1. Luke Macken triggered WARN_ON(!(group_stop & GROUP_STOP_SIGMASK))
>    in do_signal_stop().
>
>    This is because do_signal_stop() clears GROUP_STOP_SIGMASK part
>    unconditionally but doesn't update it if task_is_stopped().
>
> 2. Looking at this problem I noticed that WARN_ON_ONCE(!ptrace) is
>    not right, a stopped-but-resumed tracee can clone the untraced
>    thread in the SIGNAL_STOP_STOPPED group, the new thread can start
>    another group-stop.
>
>    Remove this warning, we need more fixes to make it true.

Tejun, 3.1 has similar problems. I'll write another email...

Oleg.

