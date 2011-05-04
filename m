Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1EDPit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:38:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59673 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab1EDPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:38:47 -0400
Date: Wed, 4 May 2011 10:38:19 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ath5k regression associating with APs in 2.6.38
Message-ID: <20110504153819.GA4551@thinkpad-t410>
Mail-Followup-To: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been investigating some reports of a regression in associating with
APs with AR2413 in 2.6.38. Association repeatedly fails with some
"direct probe to x timed out" messages (see syslog excerpt below),
although it will generally associate eventually, after many tries.

Bisection identifies 8aec7af (ath5k: Support synth-only channel change
for AR2413/AR5413) as offending commit. Prior to this commit there are
no direct probe messages at all in the logs. I've also found that
forcing fast to false at the top of ath5k_hw_reset() fixes the issue.
I'm not sure what the connection is between this commit and the
timeouts. Any suggestions?

Thanks,
Seth


May  4 09:32:15 AcerAspire5100 wpa_supplicant[757]: Trying to associate with c0:3f:0e:b9:f3:b2 (SSID='aureola' freq=2452 MHz)
May  4 09:32:15 AcerAspire5100 kernel: [  120.063271] wlan0: direct probe to c0:3f:0e:b9:f3:b2 (try 1/3)
May  4 09:32:16 AcerAspire5100 kernel: [  120.260074] wlan0: direct probe to c0:3f:0e:b9:f3:b2 (try 2/3)
May  4 09:32:16 AcerAspire5100 kernel: [  120.460084] wlan0: direct probe to c0:3f:0e:b9:f3:b2 (try 3/3)
May  4 09:32:16 AcerAspire5100 kernel: [  120.660082] wlan0: direct probe to c0:3f:0e:b9:f3:b2 timed out
May  4 09:32:25 AcerAspire5100 wpa_supplicant[757]: Authentication with c0:3f:0e:b9:f3:b2 timed out.

