Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab2AXXxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:53:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab2AXXxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:53:04 -0500
Date: Tue, 24 Jan 2012 15:53:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] fs, proc: Introduce /proc/<pid>/task/<tid>/children
 entry v8
Message-Id: <20120124155303.acbb3b11.akpm@linux-foundation.org>
In-Reply-To: <20120123142436.181674896@openvz.org>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.181674896@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 18:20:37 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> When we do checkpoint of a task we need to know the list of children
> the task, has but there is no easy and fast way to generate reverse
> parent->children chain from arbitrary <pid> (while a parent pid is
> provided in "PPid" field of /proc/<pid>/status).
> 
> So instead of walking over all pids in the system (creating one big process
> tree in memory, just to figure out which children a task has) -- we add
> explicit /proc/<pid>/task/<tid>/children entry, because the kernel already has
> this kind of information but it is not yet exported.
> 
> This is a first level children, not the whole process tree.

Is there a reason for not putting this new code inside
CONFIG_CHECKPOINT_RESTART?  If so, please changelog that.

We could add

/* #ifdef CONFIG_CHECKPOINT_RESTART (reasoning goes here) */

so that if we should decide to pull all this code out again, a grep
will flag this code for consideration.

