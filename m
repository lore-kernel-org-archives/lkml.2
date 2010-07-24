Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0GXKaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 06:30:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33378 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0GXKaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 06:30:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=piYPUKs7A4gmj7UeGsh/NyAn5LZr8RuhJU+kYax47iX++5kF+3StHxtuM/zWmWFsHe
         dIbfE1gmesnZkR55xNEOWKcUapPWp+9/yY/x9rVKTLVAqVp5cGRxDd9tBCPGJ90yrUP/
         v/QX3iYvQ03hGBhBQHiNtcTw/H9PwB0R8RnN4=
Date: Sat, 24 Jul 2010 16:00:27 +0530
From: Rabin Vincent <rabin@rab.in>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: linux@arm.linux.org.uk, linux-arm-msm@vger.kernel.org,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] GIC: Dont disable INT in ack callback
Message-ID: <20100724103027.GA3336@debian>
References: <1279839450-6477-1-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279839450-6477-1-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 03:57:30PM -0700, Jeff Ohlstein wrote:
> Unless gic_ack_irq is called from __do_IRQ, interrupt should not
> be disabled in the ack function. Disabling the interrupt causes
> handle_edge_irq to never enable it again.

The GIC doesn't use handle_edge_irq.

Anyway, this change is correct since gic_ack_irq is currently doing a
maskack, when it should be just an ack.  However, since
GENERIC_HARDIRQS_NO__DO_IRQ is always true on ARM, I don't see a need to
add the ifndef.
