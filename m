Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab2GSRgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 13:36:11 -0400
Received: from mail.opencsw.org ([82.220.5.51]:37417 "EHLO mail.opencsw.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2GSRgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 13:36:09 -0400
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2012 13:36:09 EDT
Date: Thu, 19 Jul 2012 19:28:14 +0200
From: Attila Kinali <attila@kinali.ch>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Linux ARM kernel <linux-arm-kernel@lists.infradead.org>
Subject: commit 91013923c712e1c: 
 "irqdomain: Replace LEGACY mapping with LINEAR" breaks console on ARM
 i.mx23
Message-Id: <20120719192814.75ea8beb784bdf8bb32c510c@kinali.ch>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm working on an embedded system based on a Freescale ARM9 processor i.mx23.

While trying linux-next i stumpled over my login prompt getting broken.
What exactly happens is that the kernel boots normally, but when my
login prompt should appear it suddenly stops. I bisected it back to 
the commit 91013923c712e1c4b9b343f0ee4a86ce72b1b630
irqdomain: Replace LEGACY mapping with LINEAR

Reverting this and the three commits that directly depend on it (see below)
everything seems to work fine again

commit 91013923c712e1c4b9b343f0ee4a86ce72b1b630
    irqdomain: Replace LEGACY mapping with LINEAR
commit 79f3a92c6f1dcbd9aef748252962ec28dab130b8
    irqdomain: Reserve IRQs for legacy domain
commit 1fa5b2108e41a2c6be8f22c4d453fa97e1509f07
    irqdomain: merge linear and tree reverse mappings.


				Attila Kinali

-- 
It is upon moral qualities that a society is ultimately founded. All 
the prosperity and technological sophistication in the world is of no 
use without that foundation.
                 -- Miss Matheson, The Diamond Age, Neil Stephenson
