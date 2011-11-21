Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab1KUFV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 00:21:57 -0500
Received: from ozlabs.org ([203.10.76.45]:41205 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1KUFVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 00:21:52 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kevin Cernekee <cernekee@gmail.com>, "'Jan Beulich'" <JBeulich@suse.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] module: Fix performance regression on modules with large symbol tables
In-Reply-To: <63fcc782681c8b3bd330164871ad4785@localhost>
References: <4EC0E4040200007800060B1C@nat28.tlf.novell.com> <63fcc782681c8b3bd330164871ad4785@localhost>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 21 Nov 2011 15:36:11 +1030
Message-ID: <87ipme9i9o.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 19:15:02 -0800, Kevin Cernekee <cernekee@gmail.com> wrote:
> Potential memory savings from reusing EXACT strtab matches: 36,475 bytes
> total; 35,432 from nvidia.ko.  For comparison, discarding non-core
> strtab entries saved about 91KB on my system.
...
> Original scheme: 1.230s
> With patch V2: 0.280s
> With naive copying: 0.058s

I'm deeply tempted.  It's very simple, 46 lines shorter, preserves exact
matches, and doesn't have any strange slowdowns on corner cases.

But like Kevin, I could be convinced either way.  Jan?

Thanks,
Rusty.
