Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0FOMjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:39:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25013 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab0FOMjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:39:35 -0400
Date: Tue, 15 Jun 2010 14:38:26 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH v2] drivers: regulator: add Maxim 8998 driver
In-reply-to: <20100615121226.GE14510@rakim.wolfsonmicro.main>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
       kyungmin.park@samsung.com, sameo@linux.intel.com,
       "'Marek Szyprowski'" <m.szyprowski@samsung.com>
Message-id: <00d801cb0c87$aae7b020$00b71060$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcsMhBLAkGEdNu0mT3ChtChBpReF3QAAgHzQ
References: <1276603388-8022-1-git-send-email-m.szyprowski@samsung.com>
 <20100615121226.GE14510@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, June 15, 2010 2:12 PM Mark Brown wrote:

> On Tue, Jun 15, 2010 at 02:03:08PM +0200, Marek Szyprowski wrote:
> > From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> > This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> > is used on Samsung Aquila and GONI boards and provides following
> > functionalities:
> > - 4 BUCK voltage converters, 17 LDO power regulators and 5 other power
> >   controllers
> > - battery charger
> > - RTC
> 
> CCing in Samuel for the MFD part and hence not deleting any context.
> 
> It'd be better to make the register read/write functions part of the MFD
> driver and export them (since the RTC and so on drivers will need the
> same stuff) but other than that this looks good and I've no comments.  I
> suspect it'd be easier to review fixing the register write location as
> an incremental patch unless you need to respin for some other reason.
> 
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Are global exports preferred over the callbacks? I saw both in different
MFD drivers and was not sure which one to use.

I've selected callbacks, because they are a bit nicer and don't pollute
the name space for each single driver. In my opinion the cost of these
3 max8998_reg_{read,write,update} inline functions in regulator/max8998.c
is not so significant.

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



