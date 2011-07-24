Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1GXUrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 16:47:20 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38831 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab1GXUrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 16:47:17 -0400
Date: Sun, 24 Jul 2011 16:39:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: johannes.berg@intel.com, wey-yi.w.guy@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlagn: wrap suspend/resume definitions in CONFIG_PM
 block
Message-ID: <20110724203956.GA29630@tuxdriver.com>
References: <20110724.030949.1727841105144911931.davem@davemloft.net>
 <1311535150-28686-1-git-send-email-linville@tuxdriver.com>
 <20110724.130840.1093555047179460794.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724.130840.1093555047179460794.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 01:08:40PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Sun, 24 Jul 2011 15:19:10 -0400
> 
> > drivers/net/wireless/iwlwifi/iwl-agn.c:3464: error: unknown field 'suspend' specified in initializer
> > drivers/net/wireless/iwlwifi/iwl-agn.c:3464: warning: initialization from incompatible pointer type
> > drivers/net/wireless/iwlwifi/iwl-agn.c:3465: error: unknown field 'resume' specified in initializer
> > drivers/net/wireless/iwlwifi/iwl-agn.c:3465: warning: initialization from incompatible pointer type
> > 
> > This was caused by commit c8ac61cf ("iwlagn: implement WoWLAN").
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Since I already minimally fixed up my build locally last night I know
> that your patch leads to a set of warnings because the methods whose
> hookup are now commented out become completely unused and they are all
> marked "static".  And recursively functions that those methods use
> become unused too.
> 
> Did you turn off CONFIG_PM and test the build of this file to see
> what the compiler actually does with it?
> 
> I'm checking in the following, but I expect much better from you John.

Sorry, Dave.  I confess that I was hoping for a quick fix on a Sunday afternoon. :-)

Thanks for making it better!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
