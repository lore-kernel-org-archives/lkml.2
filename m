Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659Ab0IHL4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 07:56:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633Ab0IHLzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 07:55:55 -0400
Date: Wed, 8 Sep 2010 13:55:53 +0200
From: Michal Marek <mmarek@suse.cz>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kbuild@vger.kernel.org,
        aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: fix oldnoconfig to do the right thing
Message-ID: <20100908115553.GC2617@sepie.suse.cz>
References: <20100901152130.GY2684@bombadil.infradead.org>
 <20100905061758.GA29547@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100905061758.GA29547@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 05, 2010 at 08:17:58AM +0200, Sam Ravnborg wrote:
> On Wed, Sep 01, 2010 at 11:21:30AM -0400, Kyle McMartin wrote:
> > From: Kyle McMartin <kyle@redhat.com>
> > 
> > Commit 861b4ea4 broke oldnoconfig when removed the oldnoconfig checks on
> >                        if (input_mode == nonint_oldconfig ||
> >                            input_mode == oldnoconfig) {
> >                                if (input_mode == nonint_oldconfig &&
> >                                    sym->name &&
> >                                     !sym_is_choice_value(sym)) {
> > to avoid oldnoconfig chugging through the else stanza.
> > 
> > Fix that to restore expected behaviour (which I've confirmed in the
> > Fedora kernel build that the configs end up looking the same.)
> 
> I played aroud with this.
> I looks like the only difference I got was that before
> your patch oldnoconfig produced a lot of output to stdout.
> With your patch is was silent.
> 
> The resulting config was the same.

I found that when running make oldnoconfig on the kconfig branch of
kbuild.git (which is currently a 2.6.35 + kconfig changes) against a
2.6.35-rc1 x86_64 defconfig, it mysteriously switches from
CONFIG_KERNEL_GZIP=y to CONFIG_KERNEL_LZO=y. With Kyle's patch it
doesn't do this. I applied the patch now.

Michal
