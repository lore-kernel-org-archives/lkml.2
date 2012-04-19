Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab2DSUoy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:44:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab2DSUox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:44:53 -0400
Date: Thu, 19 Apr 2012 16:44:44 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] ite-cir: postpone ISR registration
Message-ID: <20120419204444.GB5165@redhat.com>
References: <1334782447-8742-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334782447-8742-1-git-send-email-luis.henriques@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 09:54:07PM +0100, Luis Henriques wrote:
> An early registration of an ISR was causing a crash to several users (for
> example here: http://bugs.launchpad.net/bugs/972723  The reason was that
> IRQs were being triggered before the driver initialisation was completed.
> 
> This patch fixes this by moving the invocation to request_irq() to a later
> stage on the driver probe function.

Ugh. Looks like we actually have a similar problem with multiple lpc super
i/o based CIR drivers. I'd probably move both the irq and io region
requests in ite-cir, fintek-cir, nuvoton-cir, ene_ir and winbond-cir. If
I'm thinking clearly, I've actually seen a very similar report for one of
the other CIR drivers recently. Good catch. But yeah, lets do the same for
all the drivers, and move request_region as well.

-- 
Jarod Wilson
jarod@redhat.com

