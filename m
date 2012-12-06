Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2LFCPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 21:15:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab2LFCO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 21:14:59 -0500
Date: Wed, 5 Dec 2012 21:14:53 -0500
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] dynamic_debug: Add print_hex_dump_bytes/debug
 support and cleanups
Message-ID: <20121206021453.GA2834@redhat.com>
References: <cover.1354741891.git.jbaron@redhat.com>
 <1354745106.8320.12.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354745106.8320.12.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 02:05:06PM -0800, Joe Perches wrote:
> On Wed, 2012-12-05 at 16:48 -0500, Jason Baron wrote:
> > Here's a collection of the latest dynamic debug patches that I have
> > pending. 
> 
> Any update on the jump table support?
> 

I have patches that implement the support, although they are a bit hacky
due to header dependencies. However, the main reason I didn't post them
yet is that the 'data' section increases quite a bit due to the
increased table size (text section is reduced, since we are saving
instructions). On x86_64, the the upper 32-bits of each table entry are
always '0xffffffff', so the table could be reduced by a factor of 2.
Although, I haven't figured out a simple way of doing so. Perhaps, the
'data' section bloat is ok, due to the runtime savings, though. I can
dig out the % increase data.

While we're on new features, I think it would be nice to have the ability
to enable the core dynamic debug library - lib/dynamic_debug.c,
independently from the debug statements that use it. So, having
CONFIG_DYNAMIC_DEBUG would just configure the infrastructure bits, and
something such as CONFIG_DYNAMIC_DEBUG_PRINTK could enable pr_debug() and
friends. In that way subsystems that want to use dynamic output can be
enabled/disabled independently. So they could do:

#ifdef CONFIG_DRIVER_FOO_DEBUG
 #define drv_foo_debug() dev_dbg()
#else
 #define drv_foo_debug() {}


where CONFIG_DRIVER_FOO_DEBUG would enable CONFIG_DYNAMIC_DEBUG.

Thanks,

-Jason
