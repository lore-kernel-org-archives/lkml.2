Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab2ARUr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:47:26 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47491 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2ARUrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:47:25 -0500
Date: Wed, 18 Jan 2012 20:46:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Jones <drjones@redhat.com>, rientjes@google.com, mingo@elte.hu,
        david.woodhouse@intel.com, linux-kernel@vger.kernel.org,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, arnd@arndb.de,
        holt@sgi.com, linux-arch@vger.kernel.org, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper nilsson <jesper.nilsson@axis.com>,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120118204639.GO1068@n2100.arm.linux.org.uk>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com> <20120118122830.037f1e29.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118122830.037f1e29.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 12:28:30PM -0800, Andrew Morton wrote:
> I can see an argument for retaining EXPERIMENTAL: as a way of telling
> people that the particular feature might not yet be ready for prime
> time.  But I suggest that we tip both CONFIG_EXPERT and CONFIG_EMBEDDED
> into the ole bit bucket.  What do you guys think would be the negative
> consequences of doing this?

The negative effect is that x86 will continue wanting to have things
like ATKBD enabled, where that's not appropraite for other architectures.
Eg, on ARM, we really want that to default to 'n' for the fast majority
of our platforms.

I've lost count of the times in the past that I ended up with ATKBD
inappropriately enabled in the past, or I8042 or something like that,
and had problems as a result.

I'll also mention that I've given up with the Kconfig tools - my way of
configuring the kernel now is solidly an editor on .config and make
oldconfig, even for simple changes like changing the compression format
for zImage.

The last time I seriously interacted with the Kconfig tools was when I
built 3.1.8 for the laptop, from a 2.6.35.14 based config - and spent
something like 30 minutes dealing with 'make oldconfig', each option
occupying about a second of my attention before giving it an answer.

I believe kernel configuration has positively become a nightmare, one
which no one sane would undertake.
