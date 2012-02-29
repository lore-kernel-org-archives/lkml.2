Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030780Ab2B2HEV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:04:21 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:43265 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063Ab2B2HET convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:04:19 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 00/12] Part 2: check given MAC address, if invalid return -EADDRNOTAVAIL
Date: Wed, 29 Feb 2012 08:02:49 +0100
User-Agent: KMail/1.9.10
Cc: =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Gospodarek <andy@greyhouse.net>,
        "Guo-Fu Tseng" <cooldavid@cooldavid.org>,
        Petko Manolov <petkan@users.sourceforge.net>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        "John W. Linville" <linville@tuxdriver.com>, linux390@de.ibm.com,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Joe Perches <joe@perches.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-hams@vger.kernel.org, linux-mips@linux-mips.org
References: <1330099282-4588-1-git-send-email-danny.kukawka@bisect.de> <CAHXqBFK=u+MchBn=D31h6nhp-R9GTNbaC18QJA937zjXc60UQw@mail.gmail.com> <CAMuHMdVZ8eVdRLtsq23XCLtA4wU7cTc-mLebAQ4QzO=gkuNMWQ@mail.gmail.com>
In-Reply-To: <CAMuHMdVZ8eVdRLtsq23XCLtA4wU7cTc-mLebAQ4QzO=gkuNMWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201202290802.52234.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1330499058;998fed62;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag, 25. Februar 2012, Geert Uytterhoeven wrote:
> 2012/2/24 Michał Mirosław <mirqus@gmail.com>:
> > 2012/2/24 Danny Kukawka <danny.kukawka@bisect.de>:
> >> Second Part of series patches to unifiy the return value of
> >> .ndo_set_mac_address if the given address isn't valid.
> >>
> >> These changes check if a given (MAC) address is valid in
> >> .ndo_set_mac_address, if invalid return -EADDRNOTAVAIL
> >> as eth_mac_addr() already does if is_valid_ether_addr() fails.
> >
> > Why not just fix dev_set_mac_address() and make do_setlink() use that?
>
> BTW, it's also called from dev_set_mac_address().
>
> > Checks are specific to address family, not device model I assume.
>
> Indeed, why can't this be done in one single place, instead of sprinkling
> these checks over all drivers, missing all out-of-tree (note: I don't care)
> and all soon-to-be-submitted drivers?

Since the .ndo_set_mac_address functions are used by some drivers internally 
too, you may get some new checks on other places. But I'll take a look at it.

Danny

