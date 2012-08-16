Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2HPEId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 00:08:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32908 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2HPEIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 00:08:31 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-ce-502c723dfa33
From: IAN CHEN <ian.cy.chen@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
References: <5029F8F6.1080207@samsung.com>
 <CACRpkdYNKxjRXC=4no0p55ADkUvXTEcfW3b2z+Exg=cpHCtAAQ@mail.gmail.com>
In-reply-to: <CACRpkdYNKxjRXC=4no0p55ADkUvXTEcfW3b2z+Exg=cpHCtAAQ@mail.gmail.com>
Subject: RE: [PATCH v3] mmc: card: Skip secure option for MoviNAND.
Date: Thu, 16 Aug 2012 13:09:39 +0900
Message-id: <000f01cd7b64$f70f6620$e52e3260$%cy.chen@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1588MMfjbnuA7dTyCCX4nydx/uGQBcFj0Q
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jQV3bIp0Ag/lbRS0u75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBkbVuxlKrjOWfH1jXkD4yyOLkZODgkBE4l7HefYIWwx
	iQv31rN1MXJxCAlMZ5Q4/+o4lPOXUeLK0resIFVsAhoS3w8+YQSxRQT0JN58bWEHKWIGKdrR
	dw0sISRQKLHz5yM2EJtTIFhixoZtTCC2sICzRPPvfSwgNouAqsTW7qdgQ3kFHCWOv/jCDmEL
	SvyYfA+shllAS2L9zuNMELa8xOY1b5m7GDmATlWXePRXF+IGI4nH56YxQpSIS0x68JB9AqPQ
	LCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7pZ9I7GFc1WBxi
	FOBgVOLhPfBfO0CINbGsuDL3EKMEB7OSCO+PU0Ah3pTEyqrUovz4otKc1OJDjNIcLErivCbe
	X/2FBNITS1KzU1MLUotgskwcnFINjNbL12y86xps/uORBFfQyyn9bX6lB+vf5fHYepvW9Zro
	9QiltkToXGNTulG+52qS31X7T4+SLkT9M5IOi1C4Mq/zgzFDW4XClRSztU9aj98Qz9ma0+SV
	J7PivuQi/nCdoOX3q27PPrn5kc/axpPBF7Rqbqxn0LSKa1t5+s+HknlPWrsiWw8eVGIpzkg0
	1GIuKk4EAJ/wKAplAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMC_QUIRK_SEC_ERASE_TRIM_BROKEN seems quite clear but I might not use "SEC"
due to it could be Samsung Electronics Corporation.
So, how about MMC_QUIRK_SECDISCARD_BROKEN which was used in
mmc_blk_issue_secdiscard_rq() naming, the function we skip.
Or, MMC_QUIRK_SECERASE_SECTRIM_BROKEN?

Regards,
Ian
-----Original Message-----
From: Linus Walleij [mailto:linus.walleij@linaro.org] 
Sent: Tuesday, August 14, 2012 5:07 PM
To: IAN CHEN
Cc: cjb@laptop.org; linkinjeon@gmail.com; adrian.hunter@intel.com;
subhashj@codeaurora.org; linux-mmc@vger.kernel.org;
linux-kernel@vger.kernel.org; d.j.shin@samsung.com;
jongtae22.kim@samsung.com; kyungmin.park@samsung.com; jh80.chung@samsung.com
Subject: Re: [PATCH v3] mmc: card: Skip secure option for MoviNAND.

On Tue, Aug 14, 2012 at 9:06 AM, IAN CHEN <ian.cy.chen@samsung.com> wrote:

> +#define MMC_QUIRK_SECURE_MODE_BROKEN (1<<10)   /* Skip secure for
> erase/trim */

OK this will work and sorry for being picky, but we are working with RPMB
support and that's some other "secure mode" so to avoid any
misuderstandings it's better to name the flag like I proposed,
MMC_QUIRK_SEC_ERASE_TRIM_BROKEN

I won't die if this goes in though :-)

Yours,
Linus Walleij

