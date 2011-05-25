Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab1EYRoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 13:44:54 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:44313 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1EYRox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 13:44:53 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 19:44:51 +0200
In-Reply-To: <20110525153327.GA2341@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <20110523152141.GB4019@redhat.com>
	 <20110523153848.GC2310@linux.vnet.ibm.com>
	 <1306318636.9059.33.camel@t41.thuisdomein>
	 <20110525153327.GA2341@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1306345492.21978.15.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-05-25 at 08:33 -0700, Paul E. McKenney wrote:
> On Wed, May 25, 2011 at 12:17:16PM +0200, Paul Bolle wrote:
> > 2) So shouldn't either the config entry be set to "tristate" or the
> > module support removed from kernel/rcutree_trace.c?
> 
> No.
> 
> Just set CONFIG_RCU_TRACE=y and you will have RCU tracing.  Here is why:
> 
>[...]
>
> So you can set CONFIG_RCU_TRACE, and if you are running CONFIG_SMP=y,
> you will have RCU tracing in your kernel.

The point - which I must have expressed poorly - is that there's a
mismatch between the code in kernel/rcutree_trace.c (which allows for
that file to be built as a module) and its kconfig setup (which requires
it to be either builtin or not built at all, since it's boolean).
Anyhow, your explanation makes clear that this kconfig setup is actually
correct and that the module support in kernel/rcutree_trace.c might as
well be removed, since that file can never be part of a module.


Paul Bolle

