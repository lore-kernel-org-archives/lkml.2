Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab2CEExp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 23:53:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39552 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2CEExn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 23:53:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jrnieder@gmail.com designates 10.50.46.136 as permitted sender) smtp.mail=jrnieder@gmail.com; dkim=pass header.i=jrnieder@gmail.com
Date: Sun, 4 Mar 2012 22:53:35 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 651199@bugs.debian.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andreas Gustafsson <olangu@impressions.se>,
        "Marco d'Itri" <md@Linux.IT>, Gabriel Kerneis <kerneis@pps.jussieu.fr>,
        Shawn Thompson <shawn@projektenterprises.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: iwlwifi WPA-TKIP crypto failure after group rekeying
Message-ID: <20120305045334.GF30344@burratino>
References: <1330320802.8460.105.camel@deadeye>
 <1330333354.3483.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330333354.3483.6.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Berg wrote:
> On Mon, 2012-02-27 at 05:33 +0000, Ben Hutchings wrote:

>> To summarise, a WPA-TKIP managed connection stops passing traffic and
>> the kernel log shows the message "WPA: Group rekeying".  This apparently
>> doesn't happen if the connection is in heavy use at the time or with
>> module parameter swcrypto=1.  WPA2 is not affected either.
>
> I think this is due to my patch "iwlagn: rewrite HW crypto" which
> accidentally broke key *removal* (of all things), which causes issues
> when the first GTK is removed on the second rekeying.
>
> This patch
> [...]h=5dcbf480473f6c3f06ad2426b7517038a2a18911
>
> should fix it. Wey has sent it to John
[...]
> it's also marked for stable.

Shawn Thompson (cc-ed) tested the patch against 3.2.9 and 3.3-rc6 and
found it to work[1].  What can interested people do to help usher this
into mainline?

(To recap, this was a regression introduced between 3.0 and 3.1,
presumably by v3.1-rc1~24^2~10^2^2~37.)

Thanks,
Jonathan

[1] http://bugs.debian.org/651199#147
