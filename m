Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2ARU2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 15:28:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757135Ab2ARU2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 15:28:32 -0500
Date: Wed, 18 Jan 2012 12:28:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Jones <drjones@redhat.com>
Cc: rientjes@google.com, mingo@elte.hu, david.woodhouse@intel.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
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
Message-Id: <20120118122830.037f1e29.akpm@linux-foundation.org>
In-Reply-To: <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
	<b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 06:08:30 -0500 (EST)
Andrew Jones <drjones@redhat.com> wrote:

> CONFIG_EMBEDDED to CONFIG_EXPERT

I don't think either of these things have been successful.  At least, I
haven't seen any evidence of it.

My take on these is that EMBEDDED is a handy way for embedded kernel
developers to start out with a config which is more appropriate to an
embedded device kernel.  Of course, the resulting config will be very
different from what they eventually use in their product and I expect
that the head-start which EMBEDDED gave was of negligible benefit.

The development lifetime for an embedded product kernel is months, more
likely years.  The team will invest the time to carefully select and
maintain their kernel configuration.

IOW, I expect that EMBEDDED is useless and we may as well do away with it.


And ditto EXPERT.  Is there really any benefit in hiding config options
from developers so they won't burn their fingers?  Or is there some
other reason for EXPERT?

Anyway, we already have a way to prevent fingers from getting burnt:
defconfig.  Start out with that and carefully modify it.


I can see an argument for retaining EXPERIMENTAL: as a way of telling
people that the particular feature might not yet be ready for prime
time.  But I suggest that we tip both CONFIG_EXPERT and CONFIG_EMBEDDED
into the ole bit bucket.  What do you guys think would be the negative
consequences of doing this?
