Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932744Ab2DZAmq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 20:42:46 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:55309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab2DZAmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 20:42:44 -0400
Date: Wed, 25 Apr 2012 20:42:31 -0400 (EDT)
Message-Id: <20120425.204231.1586199621022282253.davem@davemloft.net>
To: krzysztof.wilczynski@linux.com
Cc: isdn@linux-pingi.de, gregkh@linuxfoundation.org, horms@verge.net.au,
        trivial@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mISDN: Ignore return value of driver_for_each_device
 in function hfcpci_softirq.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1335309230-23428-1-git-send-email-krzysztof.wilczynski@linux.com>
References: <1335309230-23428-1-git-send-email-krzysztof.wilczynski@linux.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 17:42:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3Q0gqDd010358

From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Date: Wed, 25 Apr 2012 00:13:50 +0100

> Function hfcpci_softirq uses driver_for_each_device to call _hfcpci_softirq for
> each device. Given that _hfcpci_softirq always returns 0, we collect this return
> value and simply do nothing with it.  This is purely to address the following
> warning during compilation time:
> 
>   drivers/isdn/hardware/mISDN/hfcpci.c: In function ¡hfcpci_softirq¢:
>   drivers/isdn/hardware/mISDN/hfcpci.c:2319: warning: ignoring return value of
>     ¡driver_for_each_device¢, declared with attribute warn_unused_result
> 
> Similar approach was used in function cx18_alsa_exit from "cx18-alsa-main.c".
> 
> Signed-off-by: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>

There is no value in the warning if we simply convert each such case
to ignore the return value.

I'm not applying this, at least not with a more intelligent analysis
of why any error or other non-zero value signalled by
driver_for_each_device should be completely ignored, and no error
handling should be performed.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
