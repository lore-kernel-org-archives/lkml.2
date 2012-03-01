Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965422Ab2CAAio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:38:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44316 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644Ab2CAAim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:38:42 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of tomoya.rohm@gmail.com designates 10.68.190.8 as permitted sender) smtp.mail=tomoya.rohm@gmail.com; dkim=pass header.i=tomoya.rohm@gmail.com
MIME-Version: 1.0
In-Reply-To: <cover.1330539597.git.dvhart@linux.intel.com>
References: <cover.1330539597.git.dvhart@linux.intel.com>
Date: Thu, 1 Mar 2012 09:38:42 +0900
Message-ID: <CANKRQnhFVJAUHAg0qTPFJ8L0L_+-_q4ZtfOnV0wSR1Xa6Mn8UQ@mail.gmail.com>
Subject: Re: [PATCH 0/4 V2] pch_uart: Cleanups, board quirks, and user uartclk parameter
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>, Alan Cox <alan@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Darren's patch series, I think OK.
However, need to proceed next step.

As I said before,
internal clock(USB_48MHz) should be used than external clock(UART_CLK)
as default setting.
--Reasons
  - Users don't always use 1.8432MHz as UART_CLK.
    So,  In case of using except 1.8432MHz,
    the user needs to change both pch_phub and pch_uart setting (It's
bother things).
  - High baud rate can't be used more than 115Kbps

I think there is no merit to use UART_CLK.

---Merit to use 192MHz
  - Users don't have to care both pch_phub and pch_uart clock setting.
  - High baud rate can be supported

thanks,

ROHM Co., Ltd.
tomoya
