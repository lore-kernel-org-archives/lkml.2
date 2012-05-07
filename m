Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2EGWRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 18:17:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36461 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2EGWRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 18:17:17 -0400
Date: Mon, 7 May 2012 23:17:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: Speed up deactivate_super for non-modular
 filesystems
Message-ID: <20120507221706.GI22082@ZenIV.linux.org.uk>
References: <1336124716.25479.36.camel@marge.simpson.net>
 <m1vckcdoey.fsf@fess.ebiederm.org>
 <1336142995.25479.49.camel@marge.simpson.net>
 <m1zk9oc61j.fsf@fess.ebiederm.org>
 <1336150643.7502.4.camel@marge.simpson.net>
 <m1fwbfd71h.fsf@fess.ebiederm.org>
 <1336197362.7346.9.camel@marge.simpson.net>
 <1336198093.7346.11.camel@marge.simpson.net>
 <1336201977.7346.22.camel@marge.simpson.net>
 <87r4uv64oj.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r4uv64oj.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 02:51:08PM -0700, Eric W. Biederman wrote:

> /proc and similar non-modular filesystems do not need a rcu_barrier
> in deactivate_locked_super.  Being non-modular there is no danger
> of the rcu callback running after the module is unloaded.

There's more than just a module unload there, though - actual freeing
struct super_block also happens past that rcu_barrier()...
