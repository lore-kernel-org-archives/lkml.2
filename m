Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab1CUIUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:20:42 -0400
Received: from cantor.suse.de ([195.135.220.2]:60567 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab1CUIUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:20:39 -0400
Date: Mon, 21 Mar 2011 09:20:38 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>, libc-alpha@sourceware.org,
        GCC Development <gcc@gcc.gnu.org>, LKML <linux-kernel@vger.kernel.org>,
        x32-abi@googlegroups.com
Subject: Re: X32 psABI status update
In-Reply-To: <AANLkTimxWQZvtpe374Yju0O9BDMxDfBHsc1y3+c=M7D+@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1103210907530.20892@wotan.suse.de>
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
 <201103210108.49780.vapier@gentoo.org> <AANLkTikSJDGEWCqazvAKHUC8_MoOP-+vyFOjyCmrA9dL@mail.gmail.com>
 <201103210153.10145.vapier@gentoo.org> <AANLkTimxWQZvtpe374Yju0O9BDMxDfBHsc1y3+c=M7D+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 20 Mar 2011, H.J. Lu wrote:

> I don't think it will help x32 and I think it will make it harder to add 
> x32 support. I still want to see a real usage before I add it.

% cat real-world.c
/* intptr_t; what's that? */
union space_saving_htab_element {
  void *generic_pointer;
  /* Usually we need a long for a pointer, but I just figured out
     that on x32 an int is enough and smaller.  My program
     now needs half as much memory, supi!  */
#ifdef __x32__
  unsigned int as_number;
#else
  unsigned long as_number;
#endif
};


Ciao,
Michael.
PS: Of course you and I wouldn't write such code, but Mikes point was that
there might be some that do.  I could probably construct an example where 
it would matter for real involving inline asm that for some reason has to 
slightly differ depending on x32-ness.
