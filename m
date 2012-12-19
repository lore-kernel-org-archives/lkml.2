Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2LSWNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:13:55 -0500
Received: from mail.savoirfairelinux.com ([209.172.62.77]:36290 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2LSWNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:13:49 -0500
Date: Wed, 19 Dec 2012 17:13:47 -0500 (EST)
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <1032450702.626703.1355955227194.JavaMail.root@mail.savoirfairelinux.com>
In-Reply-To: <20121219171600.7B0EF3E0C5A@localhost>
Subject: Re: [PATCH v2] gpio: add TS-5500 DIO blocks support
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [208.88.110.46]
X-Mailer: Zimbra 7.1.4_GA_2555 (ZimbraWebClient - FF3.0 (Linux)/7.1.4_GA_2555)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

> Please take a look at either send me a follow-on patch to convert it
> to use gpio-generic, or tell my why gpio-generic isn't appropriate here.

The gpio-generic driver is not appropriate here because Technologic Systems
x86-based platforms do not use a typical GPIO implementation. 
To name a few specificities:
- The GPIOs are available through ioport and not iomem
- There are input-only/output-only/input-output lines on the same block
- The number of GPIOs differs between blocks (currently 11, 13 and 14 pins)
- A single bit in a control register drives the direction of 4 input/output
  lines, while the register's other bits have different functions.

IMHO these considerations justify a specific GPIO driver to support these
Technologic Systems pin blocks.

Regards,
Vivien
