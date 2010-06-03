Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab0FCSoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:44:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:65316 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab0FCSoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:44:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,355,1272870000"; 
   d="scan'208";a="804489970"
Subject: Re: linux-next: Tree for June 3 (iwlwifi)
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <20100603172114.GA14597@tuxdriver.com>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
	 <20100603085501.ac113779.randy.dunlap@oracle.com>
	 <20100603172114.GA14597@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 10:45:57 -0700
Message-ID: <1275587157.2091.31847.camel@rchatre-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, 2010-06-03 at 10:21 -0700, John W. Linville wrote:
> On Thu, Jun 03, 2010 at 08:55:01AM -0700, Randy Dunlap wrote:
> > On Thu, 3 Jun 2010 13:47:53 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > Changes since 20100602:
> > 
> > 
> > when CONFIG_IWLAGN=n:
> > 
> > drivers/net/wireless/iwlwifi/iwl-rx.c:254: error: 'struct iwl_priv' has no member named '_agn'
> > drivers/net/wireless/iwlwifi/iwl-rx.c:303: error: 'struct iwl_priv' has no member named '_agn'
> > drivers/net/wireless/iwlwifi/iwl-rx.c:304: error: 'struct iwl_priv' has no member named '_agn'
> > drivers/net/wireless/iwlwifi/iwl-rx.c:305: error: 'struct iwl_priv' has no member named '_agn'
> > drivers/net/wireless/iwlwifi/iwl-rx.c:306: error: 'struct iwl_priv' has no member named '_agn'
> > 
> > and many more.
> > 
> > Haven't we seen this movie before?
> 
> Ugh...caused be this:
> 
> commit a2064b7a4a22d118087898e4308670da7ac07911
> Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Date:   Fri Apr 30 14:21:48 2010 -0700
> 
>     iwlwifi: move _agn statistics related structure
>     
>     agn and 3945 has different statistics_notif data structure; since 3945
>     has it statistics_notif data structure inside the _3945 portion of
>     iwl_priv, it make sense to move the agn statistics_notif into _agn portion.
>     
>     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>     Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> 
> Since iwl-rx.o is part of iwlcore.ko, this change seems wrong.

Indeed. Sorry about this.

> Reinette, any reason why I shouldn't just revert it?

No - please do revert it. I am getting an unfamiliar error when I tried
to revert it from linux-2.6 as well as wireless-testing, but perhaps it
is something your are familiar with. Please let me know if you need a
patch that will take care of the revert.

Reinette


