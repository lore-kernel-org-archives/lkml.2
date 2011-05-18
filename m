Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1ERWpz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 18:45:55 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:42349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab1ERWpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 18:45:54 -0400
Subject: Re: [PATCH v2] dma-debug: print some unfreed allocations
From: Johannes Berg <johannes@sipsolutions.net>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20110516110029.GC31309@amd.com>
References: <1305052944.3544.8.camel@jlt3.sipsolutions.net>
	 <1305118077.3416.5.camel@jlt3.sipsolutions.net>
	 <20110516110029.GC31309@amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 15:48:28 -0700
Message-ID: <1305758908.8827.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 13:00 +0200, Roedel, Joerg wrote:
> > +		/*
> > +		 * If we have, print out some stack traces for the allocations.
> > +		 * In case of module unload, the stack traces will be useless,
> > +		 * but instead of unloading the module you can manually unbind
> > +		 * the driver instead and get useful traces.
> > +		 */
> > +		printk(KERN_WARNING "Showing traces for %d allocations:\n",
> > +		       DMA_DEBUG_NUM_PRINT_UNFREED);

> This is surely useful to developers, but can trash the dmesg if done
> unconditionally. I would prefer this verbose output to be configurable
> and off by default.

Are you thinking of runtime or compile time configuration? Kconfig entry
depending on stacktrace (or selecting it, depending on have_stacktrace)
would be easy enough.

johannes

