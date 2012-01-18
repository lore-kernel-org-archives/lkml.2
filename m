Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2ARV4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 16:56:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2ARV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 16:56:01 -0500
Date: Wed, 18 Jan 2012 13:55:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Bolle <pebolle@tiscali.nl>
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
Message-Id: <20120118135559.568252e9.akpm@linux-foundation.org>
In-Reply-To: <1326923285.9412.21.camel@x61.thuisdomein>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
	<b6315f9b-0ead-4de4-a8f5-ed619f852c6c@zmail13.collab.prod.int.phx2.redhat.com>
	<20120118122830.037f1e29.akpm@linux-foundation.org>
	<1326923285.9412.21.camel@x61.thuisdomein>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 22:48:05 +0100
Paul Bolle <pebolle@tiscali.nl> wrote:

> On Wed, 2012-01-18 at 12:28 -0800, Andrew Morton wrote:
> > I can see an argument for retaining EXPERIMENTAL: as a way of telling
> > people that the particular feature might not yet be ready for prime
> > time.
> 
> The kernel configuration used for the kernels currently shipped with
> Fedora 16 and Debian 6.0.3 (ie, stable or squeeze), which are the
> configurations I can examine here, have CONFIG_EXPERIMENTAL set. Perhaps
> Debian and Fedora need that option for a few odd features. But it seems
> that the message given by having a feature depend on EXPERIMENTAL - to
> people using those configurations as a base to fine tune the kernel to
> their needs - isn't so strong.
> 

I think there's some value in telling people "this feature might blow
up".  But perhaps doing this via Kconfig dependencies wasn't the
correct implementation.  It would be better to make the feature
available, but highlight it in somme manner.  Show it in a different
colour, append the text "this feature might blow up", etc.


