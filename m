Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab2DBBGL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:06:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:58752 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933Ab2DBBGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:06:10 -0400
Message-ID: <1333328762.30734.24.camel@pasglop>
Subject: broken nouveau dependency on power supply
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Mon, 02 Apr 2012 11:06:02 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

With CONFIG_POWER_SUPPLY=m & nouveau built-in we get a build failure:

drivers/built-in.o: In function `.nouveau_pm_trigger':
(.text+0xa56e8): undefined reference to `.power_supply_is_system_supplied'

nouveau probably needs to depends on CONFIG_POWER_SUPPLY to force a module
build with the latter is =m

Cheers,
Ben.


