Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2JaXfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 19:35:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38839 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530Ab2JaXfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 19:35:02 -0400
Date: Wed, 31 Oct 2012 16:35:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, James Morris <jmorris@namei.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Message-Id: <20121031163501.79a0950e.akpm@linux-foundation.org>
In-Reply-To: <20121031160430.GD14789@redhat.com>
References: <20121031160430.GD14789@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 12:04:30 -0400
Aristeu Rozanski <aris@redhat.com> wrote:

> In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
> unchecked. root will not have a parent and trying to use
> device.{allow,deny} will cause problems.

>From my reading of the code "problems" means "kernel null pointer
dereference".

> For some reason my stressing
> scripts didn't test the root directory so I didn't catch it on my
> regular tests.
> 
> --- github.orig/security/device_cgroup.c	2012-10-26 17:18:01.739366780 -0400
> +++ github/security/device_cgroup.c	2012-10-29 10:03:33.221918003 -0400
> @@ -352,6 +352,8 @@
>   */
>  static inline int may_allow_all(struct dev_cgroup *parent)

offtopic: this function could quite neatly have a bool return type.

>  {
> +	if (!parent)
> +		return 1;

hm.  Does it need a comment explaining what and why?  I guess not...  just.

>  	return parent->behavior == DEVCG_DEFAULT_ALLOW;
>  }

