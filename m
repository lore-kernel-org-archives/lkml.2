Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab0FCRaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:30:14 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55947 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0FCRaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:30:11 -0400
Date: Thu, 3 Jun 2010 13:21:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       reinette.chatre@intel.com
Subject: Re: linux-next: Tree for June 3 (iwlwifi)
Message-ID: <20100603172114.GA14597@tuxdriver.com>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
 <20100603085501.ac113779.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603085501.ac113779.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 08:55:01AM -0700, Randy Dunlap wrote:
> On Thu, 3 Jun 2010 13:47:53 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20100602:
> 
> 
> when CONFIG_IWLAGN=n:
> 
> drivers/net/wireless/iwlwifi/iwl-rx.c:254: error: 'struct iwl_priv' has no member named '_agn'
> drivers/net/wireless/iwlwifi/iwl-rx.c:303: error: 'struct iwl_priv' has no member named '_agn'
> drivers/net/wireless/iwlwifi/iwl-rx.c:304: error: 'struct iwl_priv' has no member named '_agn'
> drivers/net/wireless/iwlwifi/iwl-rx.c:305: error: 'struct iwl_priv' has no member named '_agn'
> drivers/net/wireless/iwlwifi/iwl-rx.c:306: error: 'struct iwl_priv' has no member named '_agn'
> 
> and many more.
> 
> Haven't we seen this movie before?

Ugh...caused be this:

commit a2064b7a4a22d118087898e4308670da7ac07911
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Fri Apr 30 14:21:48 2010 -0700

    iwlwifi: move _agn statistics related structure
    
    agn and 3945 has different statistics_notif data structure; since 3945
    has it statistics_notif data structure inside the _3945 portion of
    iwl_priv, it make sense to move the agn statistics_notif into _agn portion.
    
    Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
    Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Since iwl-rx.o is part of iwlcore.ko, this change seems wrong.
Reinette, any reason why I shouldn't just revert it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
