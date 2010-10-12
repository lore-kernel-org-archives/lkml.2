Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab0JLTTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 15:19:24 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:40177 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab0JLTTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 15:19:23 -0400
Subject: RE: [PATCH] [staging] brcm80211: fix radio disabled on attempt to
 bring up interface
From: Jon Masters <jonathan@jonmasters.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: "jcm@jonmasters.org" <jcm@jonmasters.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE1382808041@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1286872198-10664-1-git-send-email-jcm@jonmasters.org>
	 <7A94256FD72B884D9E7C55586C3CBCEE1382808041@SJEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 12 Oct 2010 15:17:39 -0400
Message-ID: <1286911059.20957.5.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 11:34 -0700, Brett Rudley wrote:

> > The brcm80211 driver does not correctly handle the case that the wireless
> > radio hardware is physically disabled during interface initialization. An
> > attempt is made to check whether the radio is disabled, and in the case
> > that it is, a background worker is setup to monitor for the radio coming
> > online, but the interface queues are incorrectly brought up anyway. The
> > value BCME_RADIOOFF should be returned in wlc_up in such error case.

> Signed-off-by: Brett Rudley <brudley@broadcom.com>

Thanks. The patch actually didn't use full paths to the staging tree
(was relative to the driver directory) because it was crazy late and my
brain was tired by the time I found the problem. You'll sort it out.

Anyway. So rfkill works with soft block/unblock, but doesn't seem to
correctly report the state of the physical button on this laptop. I
don't think that's your domain (as I said, I freely admit that I need to
find some time, sometime, to understand how rfkill is supposed to work).
What I do think is your domain is the fact that suspend/resume with this
driver isn't working. The system does suspend, and it does resume, but
the driver gets itself in a twist and never talks to the outside world
again - just keeps logging an error. I'll send you some debug info
tonight or in the next few days so we can get that fixed up too.

Can I ask, also, do you plan on cleaning up the WLC HIGH/LOW stuff or
adding some comments to the code so that people realize this is for
PCI/USB dongle stuff? I spent some time going through the code trying to
figure out what the WL_LOCK/UNLOCK stuff was about and why it was
missing in the case of a PCI device :) It seems like this driver is
partly based on generic code used in other drivers, and that's fine, but
I suspect some of it will need more cleanup before it is merged.

Jon.


