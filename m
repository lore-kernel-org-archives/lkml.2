Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1D1CM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:12:59 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:6063 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1D1CM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:12:58 -0400
Subject: Re: [PATCHv3 4/7] ethtool: cosmetic: Use ethtool ethtool_cmd_speed
 API
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1303954043-17440-5-git-send-email-decot@google.com>
References: <1303954043-17440-1-git-send-email-decot@google.com>
	 <1303954043-17440-5-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 28 Apr 2011 03:12:54 +0100
Message-ID: <1303956774.3032.427.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2011 02:12:57.0847 (UTC) FILETIME=[CAB45870:01CC0549]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18098.005
X-TM-AS-Result: No--6.666200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 18:27 -0700, David Decotigny wrote:
> This updates the network drivers so that they don't access the
> ethtool_cmd::speed field directly, but use ethtoo_cmd_speed() instead.
> 
> For most drivers, these changes are purely cosmetic and don't
> fix any problem, such as for those 1GbE/10GbE drivers that indirectly
> call their own ethtool get_settings()/mii_ethtool_gset(). The changes
> are meant to enforce code consistency and provide robustness with
> future larger throughputs, at the expense of a few CPU cycles for each
> ethtool operation.
> 
> All the drivers compiled with make allyesconfig ion x86_64 have been
> updated.
> 
> Tested: make allyesconfig on x86_64 + e1000e/bnx2x work
> Signed-off-by: David Decotigny <decot@google.com>
Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

