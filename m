Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2AXEuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 23:50:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:43903 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab2AXEug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 23:50:36 -0500
Message-ID: <1327380633.19850.33.camel@pasglop>
Subject: Re: Probing unconfigured PCI bridge resouces
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-pci@vger.kernel.org
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 24 Jan 2012 15:50:33 +1100
In-Reply-To: <1327379147.19850.29.camel@pasglop>
References: <1327379147.19850.29.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-24 at 15:25 +1100, Benjamin Herrenschmidt wrote:
 .../...

> Or am I missing some important fact here ?

Ok, I think I was missing pci_bridge_check_ranges(), gotta figure now
why this didn't kick in properly for me, probably some arch code
crackpot.

One thing I noticed is that we do clear IORESOURCE_UNSET in setup-res.c
when setting up a device resource but we don't clear it for bridges in
generic code ever, so it leaks all the way through from my early arch
code. Not a big deal but annoying.

Cheers,
Ben.


