Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1BHBJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:09:52 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:14618 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753133Ab1BHBJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:09:51 -0500
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "'Wolfgang Grandegger'" <wg@grandegger.com>
Cc: <socketcan-core@lists.berlios.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <cover.1296818921.git.segoon@openwall.com><a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com><20110204124233.GB334@e-circ.dyndns.org> <20110204.130649.112613896.davem@davemloft.net> <5009516791F146C49C73FAC57C437313@hacdom.okisemi.com> <4D4FDEF9.2030305@grandegger.com>
Subject: RE: About bittiming calculation result
Date: Tue, 8 Feb 2011 10:09:48 +0900
Message-ID: <E2BAACFF191C4175854E6B2EB9135BE5@hacdom.okisemi.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <4D4FDEF9.2030305@grandegger.com>
Thread-Index: AcvGvnY9D/1fOfusQtWXGnU3k7EAIQAar9Mg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011 9:01 PM, Wolfgang Grandegger wrote
> 
> Well, only prop_seg+phase_seg=tseg1 is relevant and the 
> pch_can driver sets the allowed minimum "tseg1_min1" currently to 1:
> 
> static struct can_bittiming_const pch_can_bittiming_const = {
>         .name = KBUILD_MODNAME,
>         .tseg1_min = 1,
>         .tseg1_max = 16,
>         .tseg2_min = 1,
>         .tseg2_max = 8,
>         .sjw_max = 4,
>         .brp_min = 1,
>         .brp_max = 1024, /* 6bit + extended 4bit */
>         .brp_inc = 1,
> };
> 
> > seg1/seg2/sjw/prop_seg must be more than 1 ?
> 
> Then "tseg1_min" should be set to *2*.

Though some drivers accepted by upstream have parameter "tseg1_min" as 1,
Sould we release the patch like below ?
 -         .tseg1_min = 1,
+         .tseg1_min = 2,

Thanks,
-----------------------------------------
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

