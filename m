Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab0LVAFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:05:08 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:53062 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0LVAFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:05:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mu4tsUhVbVImsQRFpTx5dnO0HTDTqxhDFVT65u8DiUuiHiiuU6G6Ldsf+xM5JSJ3tt
         rWY2m5kv0dFvujFls2a+IFpO77Zi0ZqFgRgFP/hzsmjxqMvF9UqLVaVZhHBGfhS+w1VO
         Mq3GNJOBfMzR++gn98Jm/Mp1L89OePem2ei48=
Date: Wed, 22 Dec 2010 03:05:01 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] POWER: gpio-charger: Fix potential race between irq
 handler and probe/remove function
Message-ID: <20101222000501.GB24834@oksana.dev.rtsoft.ru>
References: <1290118119-16468-1-git-send-email-lars@metafoo.de>
 <1290118119-16468-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1290118119-16468-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:08:38PM +0100, Lars-Peter Clausen wrote:
> This patch fixes a potential race between the irq handler and the probe and
> remove functions.
> The irq should not be requested before the chargers power_supply has been
> registered and has to be freed before the power_supply is unregistered,
> otherwise it is possible that the irq fires while the power_supply is not
> initialized yet or has already been freed.
> 
> While we are at it replace request_irq with request_any_context_irq.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied to battery-2.6.git, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
