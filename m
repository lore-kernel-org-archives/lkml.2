Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab0FWTIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 15:08:17 -0400
Received: from bar.sig21.net ([80.81.252.164]:54280 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708Ab0FWTIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 15:08:16 -0400
Date: Wed, 23 Jun 2010 21:07:43 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jonathan May <jonathan.may@atheros.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
Message-ID: <20100623190743.GA22855@sig21.net>
References: <20100622172545.GA22680@srcf.ucam.org>
 <AANLkTilEHJ5qRD8ov0gIK0Zc4o-gJUPYkvHdyD1uZUon@mail.gmail.com>
 <20100622175058.GA23499@srcf.ucam.org>
 <AANLkTinE0BiOa5cpcIerbias7K-aDzj3x4qaeDpzy2CQ@mail.gmail.com>
 <20100622184426.GA24546@srcf.ucam.org>
 <20100622193143.GA17803@sig21.net>
 <AANLkTin1fAAgYTYegqaadkYIYP2NXRNRzCR48e-uIgYV@mail.gmail.com>
 <AANLkTimsEkff4sMiMB_VyWqkZOjy9PIuJ4AiC95PASOZ@mail.gmail.com>
 <20100623143940.GA5424@sig21.net>
 <AANLkTilyQB-q8Xf9Mu3F5SnKbRqbBuLjbdx8EcyCt_0v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilyQB-q8Xf9Mu3F5SnKbRqbBuLjbdx8EcyCt_0v@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.764,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 09:28:57AM -0700, Luis R. Rodriguez wrote:
> On Wed, Jun 23, 2010 at 7:39 AM, Johannes Stezenbach <js@sig21.net> wrote:
> >
> > If enabling ASPM comes with a performance penalty (which is not unexpected,
> > there is usually a tradeoff between performance and power consumption),
> > do you think a boot time option (pcie_aspm=) or compile time option
> > (CONFIG_PCIEASPM) is the right user interface?
> >
> >
> > But meanwhile I found that CONFIG_PCIEASPM has a runtime
> > interface, /sys/module/pcie_aspm/parameters/policy.
> > http://lwn.net/Articles/266585/
> 
> Same thing, its to be used by developers not users, damn it we should
> just remove this crap.

Hopefully I got at least the message across that there is
a good reason to have an interface where the user can
select the ASPM policy?

If your answer is "reboot and change the BIOS setting" then
you didn't get what I was talking about _at all_.

Also, having now briefly looked at pcie/aspm.c, I do not share your
opinion that it is crap, except maybe for the force enable.
If I read it correctly it will by default keep the BIOS settings,
but offers a per-device sysfs attribute to change the ASPM link
state, and it seems to do sanity checking, and takes care that
both ends of the link agree.

(disclaimer: I haven't tested any of it, only briefly looked at the code)


Johannes
