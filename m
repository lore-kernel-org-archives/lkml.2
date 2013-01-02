Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3ABF11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 00:27:27 -0500
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:50985
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751229Ab3ABF1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 00:27:25 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20707.50445.510814.481023@gargle.gargle.HOWL>
Date: Wed, 2 Jan 2013 10:56:37 +0530
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Fix skb leaks
In-Reply-To: <50E3BE23.3010102@lwfinger.net>
References: <1357098567-8558-1-git-send-email-Larry.Finger@lwfinger.net>
	<20707.47067.474241.813195@gargle.gargle.HOWL>
	<50E3BE23.3010102@lwfinger.net>
X-Mailer: VM 8.2.0b under 24.2.2 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> My only counter argument is that none of the other paths that get to 
> ath9k_htc_txcompletion_cb() leak the skb. It only happens for the path that goes 
> through htc_connect_service().

Sure, but the TX completion handler would be invoked for every skb that is passed
to the USB layer, including the ones that are allocated in htc_hst.c. When this
skb goes down to hif_usb.c, a URB is allocated and I am not sure how freeing
the skb before the USB layer invokes the completion handler for the URB is correct.

I'll come up with a patch and see if kmemleak still complains.

Sujith
