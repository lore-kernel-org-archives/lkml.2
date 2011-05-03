Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab1ECH6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 03:58:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51987 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1ECH6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 03:58:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 4/4] ARM: Xilinx: Adding Xilinx board support
Date: Tue, 3 May 2011 09:58:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>, johnlinn@comcast.net,
        nicolas pitre <nicolas.pitre@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        grant likely <grant.likely@secretlab.ca>,
        john linn <john.linn@xilinx.com>
References: <90477150.2231869.1304372815517.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net> <1319927287.2232106.1304373011082.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net> <20110502230118.GE28001@n2100.arm.linux.org.uk>
In-Reply-To: <20110502230118.GE28001@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105030958.14698.arnd@arndb.de>
X-Provags-ID: V02:K0:0JzjNThohJuFqGtPtLs6zoCD6YvB6JzJtptemYGhFp2
 c47GyO74kWd51umYZhJ17BYqD8hyiOmsyXaN1L7tf4i5h7VlBL
 68yXE0gV/wno84MVwnf2YeBfOViBbaMdhhGbtwOzf3fBpGjoQ6
 NLFlzLJafUCyJtB3d9Vea5ESe01yaRV4+B4KwUlsIJgPjWkGoD
 lN1PlSjBoaVagi/OFQHUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 May 2011 01:01:18 Russell King - ARM Linux wrote:
> It is preferable to use the same mapping, as it ensures that you're not
> going to create incompatible aliases.

Is aliasing a problem for MMIO mappings? I would think that you can
ioremap registers anywhere and as often as you want because they are
never cacheable.

> But, before we get too bogged down with this, please realise that it is
> possible to setup early mappings from the device tree for things like the
> SCU.  Maybe not using ioremap(), but I'm sure we can find some way to use
> the iotable_init() stuff to setup some early mappings from DT for this
> stuff.

Good point. It doesn't really matter how the entries get into the page
table, whether you call it ioremap, iotable_init, create_mapping or
ioremap_early. What matters is that we don't hardcode the physical
address in the board code, because that limits the possible reuse
on other device tree enabled targets.

	Arnd
