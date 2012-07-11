Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab2GKMdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:33:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51533 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2GKMdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:33:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2 04/23] ARM: LPC32xx: Add DMA configuration to platform data
Date: Wed, 11 Jul 2012 12:33:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com, aletes.xgr@gmail.com
References: <1339692673-7848-1-git-send-email-stigge@antcom.de> <201207102136.35944.arnd@arndb.de> <4FFD393F.1070104@antcom.de>
In-Reply-To: <4FFD393F.1070104@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207111233.24780.arnd@arndb.de>
X-Provags-ID: V02:K0:GUjd1052bPcKkUrPjTAVTIvYZRLAJFY7MvzFEg/ZmMo
 bptjQxAaSYytX3urRmMBftWJUxWg/H+d4auRSb1504XHIWWMlx
 Vjh2V6EOaY7vBtyfZo1Vqr0wsfXnEX8J75jlV5FT5dkuOtHkhe
 yyzkTXKwdkEkQXcYQDq+77dVwm6qyrPDEhehRcAuvEILXVM+Kf
 Q8/FGw7U94HH6D+lwhwHjrL3ztyOLqJRaAOMk7kxu5YMiABp3o
 l+jF8bFyHeun+XWgW6xYM1JYPkJr6YFy0gmx0AgfEJjTe9zyWN
 zcK0wnknIf3/iRsITaybG/Wa4ausXyJ4EQ8vlMT2aOeQz4KP0B
 /nYisWBFRA8ySkFojIqk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 July 2012, Roland Stigge wrote:
> Thanks for the note! Looks like the interface consolidated to replace
> ch->cd->min_signal with sth. like cd->min_signal directly.
> 
> Accessing the signal id/number is/was quite convenient because as you
> can see in the 3 above cases that now get compile errors with the pl08x
> changes, the LPC32xx chip hard-wires those numbers, and the respective
> code is LPC32xx specific anyway.
> 
> So can we make an exception here to compare static dma channel numbers?
> Or is there any other interface to access the static dma channel numbers
> that I'm currently not aware of?
> 
> Depending on what we agree upon, I can then provide fixes to the
> lpc32xx-next branch.

I'm not familiar with this code, but I think the solution for now
(while we don't have a DT binding) is to do the same thing that
spear3xx does: pass a pointer to the global pl08x_filter_id
function and an identifier for the channel in the platform data
for that device.

	Arnd
