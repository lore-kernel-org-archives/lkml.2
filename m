Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2GILCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:02:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44571 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab2GILCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:02:38 -0400
Date: Mon, 9 Jul 2012 14:02:32 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 2/5] ubi: Limit amount of reserved eraseblocks for bad
 PEB handling
Message-ID: <20120709140232.7c5a93a3@pixies.home.jungo.com>
In-Reply-To: <CACQ1gAhOtCTVVnSvso1-jq+MyminKC2i244d9je=v0acAzzRBw@mail.gmail.com>
References: <1341389164-24409-1-git-send-email-shmulik.ladkani@gmail.com>
	<1341389164-24409-3-git-send-email-shmulik.ladkani@gmail.com>
	<CACQ1gAhOtCTVVnSvso1-jq+MyminKC2i244d9je=v0acAzzRBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012 12:15:17 +0200 Richard Genoud <richard.genoud@gmail.com> wrote:
> 2012/7/4 Shmulik Ladkani <shmulik.ladkani@gmail.com>:
> > +       /*
> > +        * Calculate the actual number of PEBs currently needed to be reserved
> > +        * for future bad eraseblock handling.
> > +        */
> > +       ubi->beb_rsvd_level = ubi->bad_peb_limit - ubi->bad_peb_count;
> > +       if (ubi->beb_rsvd_level < 0) {
> > +               ubi->beb_rsvd_level = 0;
> > +               ubi_warn("number of bad PEBs (%d) is above the expected limit "
> > +                        "(%d), not reserving any PEBs for bad PEB handling, "
> > +                        "will use available PEBs (if any)",
> > +                        ubi->bad_peb_count, ubi->bad_peb_limit);
> > +       }
> >  }
> is it ok for beb_rsvd_level to be in the range [0..x[ instead of [2..x[ ?

Yes, it is ok in my new scheme.
It is even mandatory, otherwise more and more PEBs will attempt to be
reserved for future bad PEB handling (as 'beb_rsvd_pebs' always wishes
to reach 'beb_rsvd_level') even if passed the limit - this is exactly
what I'd like to fix.

Regards
Shmulik
