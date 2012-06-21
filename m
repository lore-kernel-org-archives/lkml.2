Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab2FURUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:20:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917Ab2FURUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:20:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by regulator-compatible
Date: Thu, 21 Jun 2012 17:17:45 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>, lrg@ti.com,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <201206211450.35713.arnd@arndb.de> <20120621161459.GY4037@opensource.wolfsonmicro.com>
In-Reply-To: <20120621161459.GY4037@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206211717.46142.arnd@arndb.de>
X-Provags-ID: V02:K0:MRMsLzHZYFzC9nQBBEau4izQqdske0TKu/Y4wdmneE6
 /m59VWTieAY/HGNyif8SrbdXPQYW9QQaDdZKmiDd8TLWjMgsPn
 nxdXJaf4IGGfgE/PHJZpkkgL1N85prUzkvV8yPZgOoUUNZYq/6
 vqX7wYkeAyu9ZJe+oZDD5qeYG3choxtPcJpJEUgAeNlK/31mKy
 c4c21PKEHOTqOmWc+piht/WP5jmrNac/NfV7t1VsuIOWJLRFR8
 fyAUgOz3zBgFgl0iE4VzAnO8v2wmk902XMsslVh8x7NB9BNcVR
 T3/6I0nWFhDlYTDsiLddJYooasgfLRdTjRKSEBZ8nh0/bxZA+r
 kOVOlMjzZgKoCcz3N9rg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2012, Mark Brown wrote:
>   Show Details
>   On Thu, Jun 21, 2012 at 02:50:35PM +0000, Arnd Bergmann wrote:
> 
> > It seems that the drivers that are changed to use this could also try to
> > describe the individual regulators completely, by moving the contents
> > of e.g. ab8500_regulator_info into the device tree, but having the string
> > identifier with an in-kernel table makes sense when there is only one
> > such table.
> 
> I'm not that big a fan of moving all the data into device tree as it
> means that you need even more parsing code and you need to update the
> device trees for every board out there every time you want to add
> support for a new feature which doesn't seem like a win.  Right now with
> the DT kept in the kernel it's not so bad but if we ever do start
> distributing it separately it becomes more of an issue.

Right. It's certainly a trade-off. If a company makes 100 SoCs that
all have similar-but-different regulators, then it should be clear
win to have the driver be very abstract and fed with DT data for
configuragtion.

> I'm also not sure if the tooling works well for allowing people to
> include standard DTs for chips and add new properties to nodes for the
> board specific configuration, though I think I've seen a few things
> which suggested that was dealt with reasonably well.

It should never be necessary to add board-specific properties in the
nodes that describe the SoC specific bits. What I was referring to
is just moving the data that currently resides in the regulator
driver into DT.

	Arnd
