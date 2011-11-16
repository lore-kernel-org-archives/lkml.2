Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab1KPOhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 09:37:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49584 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932557Ab1KPOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 09:37:34 -0500
Date: Wed, 16 Nov 2011 14:37:31 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Patrick Combes <p-combes@ti.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hugo Dupras <h-dupras@ti.com>
Subject: Re: [RFC][PATCH] gpiolib: add irq_wake (power-management) sysfs file
Message-ID: <20111116143731.GG29986@opensource.wolfsonmicro.com>
References: <1321004406-15663-1-git-send-email-p-combes@ti.com>
 <20111115131636.GA31028@sirena.org.uk>
 <20111116143011.GA5847@una0919255>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116143011.GA5847@una0919255>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 03:30:13PM +0100, Patrick Combes wrote:

> > ...this doesn't do anything to stop userspace doing multiple enables and
> > disables.

> Do you mean there is a need to prevent that?
> Basically the code above accepts both "1" or "enable" strings to enable the
> property. I could limit that to "enable" / "disable" if it is confusing.

That's not the problem.  The problem is that if you disable it might not
actually disable the wake if it's previously been enabled multiple times.
