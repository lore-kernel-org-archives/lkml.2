Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184Ab1KPRX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 12:23:59 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:36919 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab1KPRX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 12:23:58 -0500
Date: Wed, 16 Nov 2011 18:23:50 +0100
From: Patrick Combes <p-combes@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hugo Dupras <h-dupras@ti.com>
Subject: Re: [RFC][PATCH] gpiolib: add irq_wake (power-management) sysfs
 file
Message-ID: <20111116172347.GC5847@una0919255>
References: <1321004406-15663-1-git-send-email-p-combes@ti.com>
 <20111115131636.GA31028@sirena.org.uk>
 <20111116143011.GA5847@una0919255>
 <20111116143731.GG29986@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111116143731.GG29986@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 02:37:31PM +0000, Mark Brown wrote:
> On Wed, Nov 16, 2011 at 03:30:13PM +0100, Patrick Combes wrote:
> 
> > > ...this doesn't do anything to stop userspace doing multiple enables and
> > > disables.
> 
> > Do you mean there is a need to prevent that?
> > Basically the code above accepts both "1" or "enable" strings to enable the
> > property. I could limit that to "enable" / "disable" if it is confusing.
> 
> That's not the problem.  The problem is that if you disable it might not
> actually disable the wake if it's previously been enabled multiple times.

You're right; I however wonder if this API should work as 'enable_irq_wake' or
if it should filter multiple enables/disables. I'd have supposed it's a choice
of implementation but based on your comment I understand filtering is the
expected way. I'll modify the function accordingly. Thanks
