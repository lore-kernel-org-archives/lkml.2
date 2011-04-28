Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab1D1CEL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 22:04:11 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:5467 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1D1CEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 22:04:09 -0400
Subject: Re: [PATCHv3 2/7] ethtool: Call ethtool's get/set_settings
 callbacks with cleaned data
From: Ben Hutchings <bhutchings@solarflare.com>
To: David Decotigny <decot@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, mirq-linux@rere.qmqm.pl,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Eilon Greenstein <eilong@broadcom.com>,
        Grant Grundler <grundler@parisc-linux.org>,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <1303954043-17440-3-git-send-email-decot@google.com>
References: <1303954043-17440-1-git-send-email-decot@google.com>
	 <1303954043-17440-3-git-send-email-decot@google.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare
Date: Thu, 28 Apr 2011 03:04:04 +0100
Message-ID: <1303956244.3032.423.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Apr 2011 02:04:08.0859 (UTC) FILETIME=[8F672EB0:01CC0548]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18098.005
X-TM-AS-Result: No--9.430000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 18:27 -0700, David Decotigny wrote:
> This makes sure that when a driver calls the ethtool's
> get/set_settings() callback of another driver, the data passed to it
> is clean. This guarantees that speed_hi will be zeroed correctly if
> the called callback doesn't explicitely set it: we are sure we don't
> get a corrupted speed from the underlying driver. We also take care of
> setting the cmd field appropriately (ETHTOOL_GSET/SSET).
> 
> This applies to dev_ethtool_get_settings(), which now makes sure it
> sets up that ethtool command parameter correctly before passing it to
> drivers. This also means that whoever calls dev_ethtool_get_settings()
> does not have to clean the ethtool command parameter. This function
> also becomes an exported symbol instead of an inline.
> 
> All drivers visible to make allyesconfig under x86_64 have been
> updated.
> 
> Signed-off-by: David Decotigny <decot@google.com>
Reviewed-by: Ben Hutchings <bhutchings@solarflare.com>

-- 
Ben Hutchings, Senior Software Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

