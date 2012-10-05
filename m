Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab2JEGnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:43:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60725 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2JEGnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:43:03 -0400
Date: Fri, 5 Oct 2012 10:36:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] pidns: remove recursion from free_pid_ns
Message-ID: <20121005063602.GA1091@moon>
References: <1349385662-571743-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349385662-571743-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2012 at 01:21:02AM +0400, Andrew Vagin wrote:
> Here is a stack trace of recursion:
> free_pid_ns(parent)
>   put_pid_ns(parent)
>     kref_put(&ns->kref, free_pid_ns);
>       free_pid_ns
> 
> This patch turns recursion into loops.
> 
> pidns can be nested many times, so in case of recursion
> a simple user space program can provoke a kernel panic
> due to exceed of a kernel stack.

Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

Looks good to me. Thanks Andrew!
