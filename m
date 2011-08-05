Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab1HEJHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:07:25 -0400
Received: from cernmx30.cern.ch ([137.138.144.177]:31643 "EHLO
	CERNMX30.cern.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab1HEJHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:07:22 -0400
Date: Fri, 5 Aug 2011 11:04:16 +0200
From: Manohar Vanga <manohar.vanga@cern.ch>
To: Martyn Welch <martyn.welch@ge.com>
CC: "Emilio G. Cota" <cota@braap.org>, <gregkh@suse.de>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] staging: vme: add functions for bridge module
 refcounting
Message-ID: <20110805090416.GA4806@becoht-mvanga>
Mail-Followup-To: Martyn Welch <martyn.welch@ge.com>,
	"Emilio G. Cota" <cota@braap.org>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
References: <1312194053-32310-1-git-send-email-manohar.vanga@cern.ch>
 <1312194053-32310-6-git-send-email-manohar.vanga@cern.ch>
 <4E39555C.30507@ge.com>
 <20110803140630.GA29460@becoht-mvanga>
 <20110803152317.GA21903@flamenco.cs.columbia.edu>
 <4E3A4904.3040007@ge.com>
 <20110804163451.GA18422@flamenco.cs.columbia.edu>
 <4E3B9FA2.3060303@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4E3B9FA2.3060303@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [137.138.192.18]
Keywords: CERN SpamKiller Note: -50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Martin,

> Actually, it would give you a good indication of how many of the resources
> provided by each VME bridge chip were used. I don't see the refcount
> accurately reflecting the number of users as being important, more as a means
> of tracking which bridges have resources that are being used (and therefore
> can't be removed).

On second thought, I think I agree with Emilio that the _module_ refcount should
reflect the number of users (other modules) using the bridge module. The refcount
of resources should probably stay separate from the refcount of module usage. We
can add resource refcounting as well but I don't see a need for it at the moment.

vme_bridge_get() and vme_bridge_put() in this case should refer to the reference
count of the bridge module (not the resources). What do you think?

Thanks!

--
/manohar
