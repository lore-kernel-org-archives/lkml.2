Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab0JULaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 07:30:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43506
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755013Ab0JULaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 07:30:13 -0400
Date: Thu, 21 Oct 2010 04:30:36 -0700 (PDT)
Message-Id: <20101021.043036.57469867.davem@davemloft.net>
To: james@albanarts.com
Cc: zambrano@broadcom.com, jpirko@redhat.com, fujita.tomonori@lab.ntt.co.jp,
        hauke@hauke-m.de, Larry.Finger@lwfinger.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2] b44: fix resume, request_irq after hw reset
From: David Miller <davem@davemloft.net>
In-Reply-To: <201010171249.00485.james@albanarts.com>
References: <201010171249.00485.james@albanarts.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Hogan <james@albanarts.com>
Date: Sun, 17 Oct 2010 12:48:59 +0100

> On resume, call request_irq() after resetting the hardware rather than
> before. It's a shared interrupt so the handler could be called
> immediately if another device on the same irq interrupts (and will be
> called immediately if CONFIG_DEBUG_SHIRQ=y), but unless the hardware is
> reinitialised with b44_init_hw() the read of the interrupt status
> register will hang the system.
> 
> Signed-off-by: James Hogan <james@albanarts.com>

Applied.
