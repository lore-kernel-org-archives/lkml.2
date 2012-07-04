Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2GDDTC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 23:19:02 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47766 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744Ab2GDDS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 23:18:59 -0400
Message-ID: <1341371928.25411.2.camel@phoenix>
Subject: RE: [PATCH v2] regulator: ad5398: Fix min/max current limit
 boundary checking
From: Axel Lin <axel.lin@gmail.com>
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 04 Jul 2012 11:18:48 +0800
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D1714080606C@NWD2CMBX1.ad.analog.com>
References: <1341301353.12050.1.camel@phoenix>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805D85@NWD2CMBX1.ad.analog.com>
	 <4FF2A7F9.3090307@metafoo.de>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805DAB@NWD2CMBX1.ad.analog.com>
	 <4FF2AC24.7090906@metafoo.de>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805DC8@NWD2CMBX1.ad.analog.com>
	 <CAF+7xWk5qQa5nV3OdFM51U1Kh7g9w3dA5mLL+SGRQ7_AFNkp5A@mail.gmail.com>
	 <DB904C5425BA6F4E8424B3B51A1414D17140805E4C@NWD2CMBX1.ad.analog.com>
	 <1341315373.3158.3.camel@phoenix>
	 <DB904C5425BA6F4E8424B3B51A1414D1714080606C@NWD2CMBX1.ad.analog.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >That is why we need to add:
> >if (min_uA < chip->min_uA)
> >        min_uA = chip->min_uA;
> >
> 
> Yes, but if you apply this logic to min_uA, you should apply the same logic to max_uA, even though it is not used in your application.

Actually, the logic is the same:
to find a supported (minmal) current in specified range.

The question is the equation used in current code does not allow
min_uA < chip->min_uA.
Setting min_uA = chip->min_uA if min_uA < chip->min_uA does make sense
because botch request actually returns the same current value.
( I mean no user visible change )

Adding below logic is not necessary.
( Note: Adding this or not does not have any user visible change, it's
just not necessary)

if (max_uA > chip->min_uA)
        max_uA = chip->max_uA;

It is not necessary because the equation to choose selector does not
depends on max_uA. No matter if we set max_uA = chip->max_uA or not in
this case, it does not impact the equation to choose the selector.

But, well, if you really prefer adding it. I'll send a v3 for it.
Just let me know how do you think.

Regards,
Axel


