Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161670Ab2GLWj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:39:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60450 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161639Ab2GLWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:39:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rolf Offermanns <rolf.offermanns@gmx.net>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 064/187] ath9k_hw: avoid possible infinite loop in ar9003_get_pll_sqsum_dvc
Date: Thu, 12 Jul 2012 15:33:40 -0700
Message-Id: <20120712191528.336775659@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

commit f18e3c6b67f448ec47b3a5b242789bd3d5644879 upstream.

"ath9k: Fix softlockup in AR9485" with commit id
64bc1239c790e051ff677e023435d770d2ffa174 fixed the reported
issue, yet its better to avoid the possible infinite loop
in ar9003_get_pll_sqsum_dvc by having a timeout as suggested
by ath9k maintainers.
http://www.spinics.net/lists/linux-wireless/msg92126.html.
Based on my testing PLL's locking measurement is done in
~200us (2 iterations).

