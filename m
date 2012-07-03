Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2GCJpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:45:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47006 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2GCJof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:44:35 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <DB904C5425BA6F4E8424B3B51A1414D17140805DC8@NWD2CMBX1.ad.analog.com>
References: <1341301353.12050.1.camel@phoenix> <DB904C5425BA6F4E8424B3B51A1414D17140805D85@NWD2CMBX1.ad.analog.com>
 <4FF2A7F9.3090307@metafoo.de> <DB904C5425BA6F4E8424B3B51A1414D17140805DAB@NWD2CMBX1.ad.analog.com>
 <4FF2AC24.7090906@metafoo.de> <DB904C5425BA6F4E8424B3B51A1414D17140805DC8@NWD2CMBX1.ad.analog.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 3 Jul 2012 17:44:15 +0800
Message-ID: <CAF+7xWk5qQa5nV3OdFM51U1Kh7g9w3dA5mLL+SGRQ7_AFNkp5A@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: ad5398: Fix min/max current limit boundary checking
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>As long as it is smaller than the maximum requested current, yes. You
>>request a current range with the regulator API and any value within this
>>range is fine as the actual output current.
>>
>
> If so, please also set the max_uA as well.

The equation to calculate the selector does not depend on max_uA.
So I think we don't need to set the requested max_uA.

Current does check the selected current by:
if (ad5398_calc_current(chip, selector) > max_uA)
        return -EINVAL;

This ensures the selected current falls within specified range.

Regards,
Axel
