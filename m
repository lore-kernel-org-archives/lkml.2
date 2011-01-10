Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab1AJMiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 07:38:51 -0500
Received: from nm26.bullet.mail.sp2.yahoo.com ([98.139.91.96]:47761 "HELO
	nm26.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753698Ab1AJMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 07:38:49 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 439044.44992.bm@omp1005.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=3VfSGyDKjKah3ylAi8LQneI16ycLFfYhqKHb0W53pIf6RG6Kz/erdGGs5py9zcAanfd7NCAHyP9TSaaphTfrB/odgis7fb/7BFn9Cga+k+X95x7Y+wP+8OZGIdG5Kw4kAMLtijZ3ugzM9S/hKzUnSKDfDkdpgMdAL12VBr9ya2Y=;
Message-ID: <898333.24180.qm@web180304.mail.gq1.yahoo.com>
X-YMail-OSG: jhQJS6sVM1nrQJlOlKCqsfZMinI_IjSUlug53XKR_HZmsoC
 iHjVs7Yj4222iMuOqJ8Rbj5NV_eiVZaQ_IJefo9g0vMw5gqOm0yQRUyhHp.z
 PFAiRivDFalzxZ9EbjKLaqKgU8F32JiAYP3rZ._2_JDNYKhvz40bIEEUAjrB
 QuZyWOGXzGzT_nS15lUlHxKjYC2iucGTY0pVRwDM3wWbk9V5UDnBufRxLG5b
 eO4BxQWWfAAVpbRI9XHJQ5M_.6UYeZ.lMf735C2E_Y6iNAavuske9ffrLjjJ
 v5tFMCi.w83O5yZwRbJspRp9KaASU8TNE57h5GxNdmJ7obwUdX9VbnVBPIKT
 zm901AJ2S11wUNkkitjx3RpO7LMa1qJbZoG01uI9JWh7LWGjdA_KFD4pi0EL
 qVfxIYVA7IudxYAmI
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Mon, 10 Jan 2011 04:38:47 -0800 (PST)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH] musb: move usb_add_hcd to the core init code from gadget code (v2)
To: bryan.wu@canonical.com, Brad Parker <brad@heeltoe.com>
Cc: felipe.balbi@nokia.com, linux-usb@vger.kernel.org,
        kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
        ricardo.salveti@canonical.com, linux-omap@vger.kernel.org
In-Reply-To: <4D2AF1EE.8010105@heeltoe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> With this patch, host mode works.

What about OTG and gadget modes?

The MUSB hardware is flakey with respect to
those init issues.  Re-ordering host vs gadget
init has been a good way to waste a few months,
for anyone who has a few to waste.  (And a
better way to waste them for folk who do NOT
but just need to stay on schedule.)  One learns
quickly that the Mentor IP follows some other
state machine than the USB-OTG says, but even their
docs don't help uncover whatever init model they
are trying  to follow.


