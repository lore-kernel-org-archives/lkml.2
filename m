Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0INOg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 10:36:56 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab0INOgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 10:36:54 -0400
Subject: Re: 2.6.36-rc4/iwl: warning triggered in net/mac80211/scan.c:266
From: Johannes Berg <johannes@sipsolutions.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <20100914142814.GA8744@redhat.com>
References: <20100914142814.GA8744@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Sep 2010 16:36:28 +0200
Message-ID: <1284474988.3704.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-14 at 16:28 +0200, Michael S. Tsirkin wrote:
> I am running 2.6.36-rc4 on T60 with an iwlagn wireless card:
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN [Shiloh] Network Connection
> 
> I was compiling a large file which stressed the box heavily, and the
> following warning in net/mac80211/scan.c triggered:
> 
>         /*
>          * It's ok to abort a not-yet-running scan (that
>          * we have one at all will be verified by checking
>          * local->scan_req next), but not to complete it
>          * successfully.
>          */
>         if (WARN_ON(!local->scanning && !aborted))
>                 aborted = true;
> 
> dmesg below:
> 
> [84379.361297] ------------[ cut here ]------------
> [84379.361307] WARNING: at net/mac80211/scan.c:266 ieee80211_scan_completed+0x43/0x17f()

> Should this happen? Does anyone care?
> I am not sure how reproducible this is.

No, it shouldn't happen. But there are various races in iwlwifi that can
cause this. Stanislaw has fixed them recently, but it's a fairly large
patchset. I'm not sure, but I don't think this is really new in .36.

johannes

