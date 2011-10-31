Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1JaGn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 02:43:29 -0400
Received: from ozlabs.org ([203.10.76.45]:36167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab1JaGnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 02:43:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Decotigny <david.decotigny@google.com>, linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@xenotime.net>, Michal Schmidt <mschmidt@redhat.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        David Decotigny <david.decotigny@google.com>
Subject: Re: [PATCH v1 3/3] param: allow to selectively enable /sys/module/MOD/paramaters nodes
In-Reply-To: <d1eab40bc9015e24c2c455cf3142f7966daa827a.1319679966.git.david.decotigny@google.com>
References: <cover.1319679966.git.david.decotigny@google.com> <d1eab40bc9015e24c2c455cf3142f7966daa827a.1319679966.git.david.decotigny@google.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 31 Oct 2011 12:12:23 +1030
Message-ID: <87vcr6os1r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

        I'm having real trouble parsing your descriptions.  I found it
easier to read the patches, and that'd not good.

On Wed, 26 Oct 2011 19:22:27 -0700, David Decotigny <david.decotigny@google.com> wrote:
> This change defines CONFIG_SYSFS_MODULE_PARAM to prevent kernel module
> parameters from being exposed to user. When unset, /sys/module/MOD is
> populated as usual, except for the "parameters" sub-directory, which
> is not created anymore.

That's backwards.  CONFIG_SYSFS_MODULE_PARAM *enables*
/sys/module/<modname>/parameters, this implies it disables it.  Sure, it
allows it to be disabled without disabling all of CONFIG_SYSFS.

> Context: by default, when the module_param() attribute perm == 0, the
> module attribute is not exposed to user in
> /sys/module/*/parameters. Many module implementations use this
> strategy, presumably to spare some memory.

No, they use it because that was the default when I transferred them all
from the older module parameter system.  It was the safe choice.

> However, it can be
> interesting to retrieve how kernel modules are configured at run-time
> (debug, audit, etc.): it would be nice to see more modules have perm
> != 0 in order to expose their configuration pararemers to
> user.

But this patch doesn't address any of that.

> Unfortunately, this doesn't play well with memory-constrained
> systems that need sysfs but don't need this level of
> introspection. This change allows to support both use cases.

Do you have any statistics to support your assertion that this has any
significant effect on memory usage?

Your patches seem fine, but your descriptions are not straightforward!

Thanks,
Rusty.
