Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1HEJFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:05:20 -0400
Received: from symlink.to.noone.org ([85.10.207.172]:51621 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab1HEJFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:05:15 -0400
Date: Fri, 5 Aug 2011 11:05:14 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Colin Cross <ccross@android.com>,
        John Bonesio <bones@secretlab.ca>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, "Sam Ravnborg sam"@ravnborg.org
Subject: Re: [RFC][PATCH] of: add a dummy implementation of
	of_get_property() in of.h
Message-ID: <20110805090514.GA17391@distanz.ch>
References: <1312534574.18064.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312534574.18064.2.camel@phoenix>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-05 at 10:56:14 +0200, Axel Lin <axel.lin@gmail.com> wrote:
> Then we can avoid having #ifdef CONFIG_OF splattered around the place
> calling of_get_property(), it leads to errors.

You shouldn't redefine of_get_property in the driver. Rather add a
wrapper function to the driver which will extract the device tree
information in CONFIG_OF is enabled and which will just return -ENODEV
if CONFIG_OF is not set.

Cheers
Tobias
