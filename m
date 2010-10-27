Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0J0R4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:56:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39536 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753681Ab0J0R4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:56:17 -0400
Date: Wed, 27 Oct 2010 10:56:21 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Sundar Iyer <sundar.iyer@stericsson.com>, lrg@slimlogic.co.uk,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        STEricsson_nomadik_linux@list.st.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Bengt JONSSON <bengt.g.jonsson@stericsson.com>
Subject: Re: [PATCH v2 1/2] regulator: add support for regulators on the
 ab8500 MFD
Message-ID: <20101027175620.GB25134@opensource.wolfsonmicro.com>
References: <1279030173-3086-1-git-send-email-sundar.iyer@stericsson.com>
 <AANLkTinc50bzQawaoA_XfkLhJXjVjPWzxgbCJ40UnYwi@mail.gmail.com>
 <20101027173340.GA25134@opensource.wolfsonmicro.com>
 <AANLkTi=DRHVbz3ov_gL6qyYH673WDk+1Vyw2AvjhSRxv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=DRHVbz3ov_gL6qyYH673WDk+1Vyw2AvjhSRxv@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 03:42:53PM -0200, Thiago Farina wrote:
> On Wed, Oct 27, 2010 at 3:33 PM, Mark Brown

> > There is no reason to do this, logical values are treated as 0 and 1 in
> > C.  Using false and true is clear and won't cause any difference in
> > code.

> In C99 I suppose that is true and legal?

Yes.  C has always used 1 and 0 as the numerical mappings for logical
values, the addition of the keywords did not change them.

> >> Maybe like this?
> >> return (ret & info->mask) ? 1: 0;

> > No, that's needlessly obfuscated.

> Obfuscated? What you mean? It is a driver, and people reading and
> writing a driver would know what it means, no?

Adding the ternery operator just makes the code more noisy for no
benefit.

> Would be much simpler if it was just (like done in ab3100.c):

> return (ret & info->mask);

Yes, though there's no problem with the current code either.
