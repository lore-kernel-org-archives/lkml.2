Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab2INSjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:39:17 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:43469 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759846Ab2INSjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:39:15 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av9WABJ5U1BV5h1yPGdsb2JhbABFhR4jhQCxQBkBAQEBNzSCIAEBBAE6HCMFCwgDDjgUJQoaCogQCrtpFJEJYAOVYIVwjRo
X-IronPort-AV: E=Sophos;i="4.80,424,1344204000"; 
   d="scan'208";a="409554954"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 14 Sep 2012 20:46:36 +0200
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>, Phil Warkentin <pwar@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Input: cyttsp4 - driver for Cypress TMA4XX
 touchscreen devices
Message-ID: <20120914184636.GA2976@polaris.bitmath.org>
References: <fery@cypress.com>
 <1347644917-13269-1-git-send-email-fery@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347644917-13269-1-git-send-email-fery@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ferruh,

> This driver is for Cypress TrueTouch(tm) Standard Product controllers,
> Generation4 devices.
> 
> This is second version of driver, code re-structured to match with
> existing Generation3 driver code.

To integrate with the existing gen3 driver is clearly not the same as
creating a parallel set of files, which obviously share a lot of code
with the gen3 code.

For instance, the i2c transfer layer seems more or less identical to
the existing one; just look at cyttsp_i2c_write_block_data() versus
cyttsp4_i2c_write_block_data(). If different generations of device
data cannot even be transported through the same _generic_ interface,
something is clearly not right.

You can't seriously expect anyone to want to maintain one set of files
for every new version. Please make sure to build on what is already
there.

Thanks.
Henrik
