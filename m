Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932970Ab1KPCdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 21:33:10 -0500
Received: from ozlabs.org ([203.10.76.45]:37125 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab1KPCdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 21:33:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jan Beulich <JBeulich@suse.com>, Kevin Cernekee <cernekee@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] module: Fix performance regression on modules with large symbol tables
In-Reply-To: <4EC0E4040200007800060B1C@nat28.tlf.novell.com>
References: <73defb5e4bca04a6431392cc341112b1@localhost> <e80b536093214489c32ce319b54b0f80@localhost> <4EC0E4040200007800060B1C@nat28.tlf.novell.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 16 Nov 2011 10:54:27 +1030
Message-ID: <87y5vgoqx0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Nov 2011 08:48:52 +0000, "Jan Beulich" <JBeulich@suse.com> wrote:
> > +		name = &mod->strtab[src->st_name];
> > +		if (unlikely(!test_bit(src->st_name, info->strmap))) {
> > +			/* Symbol name has already been copied; find it. */
> > +			char *dup;
> > +
> > +			for (dup = mod->core_strtab; strcmp(dup, name); dup++)
> > +				BUG_ON(dup > s);
> 
> Aren't you concerned that this again will be rather slow? It would be
> pretty easy to accelerate by comparing only with the tail of each string
> (as nothing else can possibly match), moving from string to string instead
> of from character to character.

Kevin's central thesis is that this is actually really unusual.

I'm not sure how much faster a tail search would be in practice.  We're
still scanning the string.  Perhaps a "dup[0] == name[0] &&" would
optimize it almost as well, if gcc doesn't already?

Kevin, you're probably in an optimal position to get numbers on this?

Thanks,
Rusty.
