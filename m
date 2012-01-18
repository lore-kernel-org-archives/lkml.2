Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab2ARVgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:36:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab2ARVgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:36:21 -0500
Date: Wed, 18 Jan 2012 13:36:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Jones <drjones@redhat.com>, rientjes@google.com, mingo@elte.hu,
        david.woodhouse@intel.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, arnd@arndb.de,
        holt@sgi.com, linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com,
        jesper nilsson <jesper.nilsson@axis.com>, dhowells@redhat.com,
        takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-Id: <20120118133618.48948662.akpm@linux-foundation.org>
In-Reply-To: <20120118210441.GA4728@p183.telecom.by>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
	<b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
	<20120118122830.037f1e29.akpm@linux-foundation.org>
	<20120118210441.GA4728@p183.telecom.by>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jan 2012 00:04:41 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Jan 18, 2012 at 12:28:30PM -0800, Andrew Morton wrote:
> > And ditto EXPERT.  Is there really any benefit in hiding config options
> > from developers so they won't burn their fingers?  Or is there some
> > other reason for EXPERT?
> 
> Absolutely.
> 
> If say CONFIG_TMPFS is disabled, Debian simply won't boot past
> init scripts. Or CONFIG_UNIX (I'm almost sure, reasonably
> modern distro is unusable anyway).
> 

If you screw up your kernel config, the resulting kernel won't work
right.  There are countless ways of doing this.  You go back to the
previous .config and try again.


Is there some benefit to handholding people in a few special cases? 
Well yes, I suppose so.  But does that benefit justify all the gunk
we've added to Kconfig to implement it?   I don't think so.

