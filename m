Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab2DZPJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:09:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38750 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756375Ab2DZPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:09:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120425.204231.1586199621022282253.davem@davemloft.net>
References: <1335309230-23428-1-git-send-email-krzysztof.wilczynski@linux.com> <20120425.204231.1586199621022282253.davem@davemloft.net>
From: Krzysztof Wilczynski <krzysztof.wilczynski@linux.com>
Date: Thu, 26 Apr 2012 16:08:44 +0100
X-Google-Sender-Auth: lOm532tdUvZxesH51a-6QHWQAvQ
Message-ID: <CAC52Y8Z_QpnVA37i1GYTWdx5sydVCcke+7dbVx=pCftT3=P5nw@mail.gmail.com>
Subject: Re: [PATCH] mISDN: Ignore return value of driver_for_each_device in
 function hfcpci_softirq.
To: David Miller <davem@davemloft.net>
Cc: isdn@linux-pingi.de, gregkh@linuxfoundation.org, horms@verge.net.au,
        trivial@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[...]
> I'm not applying this, at least not with a more intelligent analysis
> of why any error or other non-zero value signalled by
> driver_for_each_device should be completely ignored, and no error
> handling should be performed.

This is a fair point.  It should not be ignored.  I was looking through
the code and found few cases where the return value was not checked
for potential errors (I assume that it was collected to avoid warning being
produced, but that was about it) without printing an error message.

The following could most certainly use better error reporting concerning
use of driver_for_each_device:

drivers/isdn/hardware/mISDN/hfcpci.c
drivers/media/video/cx18/cx18-alsa-main.c
drivers/media/video/ivtv/ivtvfb.c

I will look into it making suitable changes.  Thanks for pointing it
out to me! :)

KW
