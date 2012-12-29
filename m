Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459Ab2L2IIf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 03:08:35 -0500
Received: from mout0.freenet.de ([195.4.92.90]:40377 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab2L2IIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 03:08:30 -0500
Message-ID: <50DEA41E.6010409@01019freenet.de>
Date: Sat, 29 Dec 2012 09:04:46 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [ 104/173] rt2x00: Dont let mac80211 send a BAR when an AMPDU
 subframe fails
References: <20121228190352.097882544@decadent.org.uk>
In-Reply-To: <20121228190352.097882544@decadent.org.uk>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Andreas Hartmann <andihartmann@01019freenet.de>
> 
> commit be03d4a45c09ee5100d3aaaedd087f19bc20d01f upstream.

[...]

This patch is a workaround for

mac80211: retry sending failed BAR frames later instead of tearing down
aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html -
f0425beda4d404a6e751439b562100b902ba9c98)
See:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/83297/focus=83304


Meanwhile there was a bug report complaining about problems with
be03d4a45 when used as STA:
http://thread.gmane.org/gmane.linux.drivers.rt2x00.user/1257
You can find there a few other workaround proposals.


Stanislaw Gruszka proposed here a final(?) workaround, which refines
workaround be03d4a45c by shrinking it to AP function:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/100793


carl9170 had the same problem with f0425beda. There it was fixed like
this:
http://thread.gmane.org/gmane.linux.kernel.wireless.general/100793/focus=1405
This approach fixes the real problem (no aggregation handling by the
firmware / hardware) by implementing it into the driver.

Unfortunately, I didn't see any implementation of c9122c0d63a50 for
rt2x00 until now.



Kind regards,
Andreas Hartmann
