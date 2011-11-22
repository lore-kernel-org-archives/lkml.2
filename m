Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab1KVAr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 19:47:57 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:60551 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab1KVArz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 19:47:55 -0500
Date: Mon, 21 Nov 2011 18:47:47 -0600
From: David Fries <david@fries.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Yunpeng Gao <yunpeng.gao@intel.com>
Subject: Re: [PATCH] sdhci-pci register legacy PCI PM or runtime PM not both
Message-ID: <20111122004747.GN24999@spacedout.fries.net>
References: <20111120212951.GA4577@spacedout.fries.net>
 <4ECA1054.6050805@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECA1054.6050805@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Mon, 21 Nov 2011 18:47:48 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:48:20AM +0200, Adrian Hunter wrote:
> On 20/11/11 23:29, David Fries wrote:
> > From: David Fries <David@Fries.net>
> > 
> > pci_has_legacy_pm_support says to not register both legacy PM
> > and runtime PM callbacks, modified ifdefs.
> 
> Hasn't this already been done in Chris mmc tree i.e.
> 
> commit f353f593fe449178a8cb01cefe559dba125ab8b1
> Author: Manuel Lauss <manuel.lauss@googlemail.com>
> Date:   Thu Nov 3 11:09:45 2011 +0100
> 
>     mmc: sdhci: remove "state" argument from sdhci_suspend_host

Good call.  It looks like a better solution than what I posted.  I
tried it and it also worked.  I would classify this as a regression in
mainline (suspend didn't used to generate warnings) until a fix is
merged.  I'm good for now, but I doubt I'll be the only one running
into it.

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
