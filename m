Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab2ARWOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:14:31 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59102 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2ARWOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:14:30 -0500
Date: Wed, 18 Jan 2012 22:13:54 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, Andrew Jones <drjones@redhat.com>,
        rientjes@google.com, mingo@elte.hu, david.woodhouse@intel.com,
        linux-kernel@vger.kernel.org, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, arnd@arndb.de, holt@sgi.com,
        linux-arch@vger.kernel.org, hskinnemoen@gmail.com,
        egtvedt@samfundet.no, msalter@redhat.com, a-jacquiot@ti.com,
        starvik@axis.com, jesper nilsson <jesper.nilsson@axis.com>,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake koichi <yasutake.koichi@jp.panasonic.com>, jonas@southpole.se,
        kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
        chris@zankel.net, greg@kroah.com, davej@redhat.com, airlied@linux.ie,
        jkosina@suse.cz, mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120118221354.GR1068@n2100.arm.linux.org.uk>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com> <20120118122830.037f1e29.akpm@linux-foundation.org> <1326923285.9412.21.camel@x61.thuisdomein> <20120118135559.568252e9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120118135559.568252e9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 01:55:59PM -0800, Andrew Morton wrote:
> I think there's some value in telling people "this feature might blow
> up".  But perhaps doing this via Kconfig dependencies wasn't the
> correct implementation.  It would be better to make the feature
> available, but highlight it in somme manner.  Show it in a different
> colour, append the text "this feature might blow up", etc.

Well, in theory all "experimental" options should depend on EXPERIMENTAL
_and_ have (EXPERIMENTAL) at the end of the option text.

In reality, people forget to add (EXPERIMENTAL).  People also forget about
the option and never remove this status.

I don't think any solution (such as different colouring) would solve that -
because those of us who are in theory supposed to sort this out are the
ones who don't use the configuration tools!  (which is probably why they
get forgotten in the first place.)

There's one telling thing though: there is not one ARM defconfig which
has EXPERIMENTAL unset...  Across all architectures, there's 16 which
have it unset and 361 which the option is set.
