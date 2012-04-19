Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab2DSVcl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:32:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57246 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2DSVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:32:31 -0400
Date: Thu, 19 Apr 2012 22:32:26 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] ite-cir: postpone ISR registration
Message-ID: <20120419213226.GC22948@zeus>
References: <1334782447-8742-1-git-send-email-luis.henriques@canonical.com>
 <20120419204444.GB5165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419204444.GB5165@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 04:44:44PM -0400, Jarod Wilson wrote:
> On Wed, Apr 18, 2012 at 09:54:07PM +0100, Luis Henriques wrote:
> > An early registration of an ISR was causing a crash to several users (for
> > example here: http://bugs.launchpad.net/bugs/972723  The reason was that
> > IRQs were being triggered before the driver initialisation was completed.
> > 
> > This patch fixes this by moving the invocation to request_irq() to a later
> > stage on the driver probe function.
> 
> Ugh. Looks like we actually have a similar problem with multiple lpc super
> i/o based CIR drivers. I'd probably move both the irq and io region
> requests in ite-cir, fintek-cir, nuvoton-cir, ene_ir and winbond-cir. If
> I'm thinking clearly, I've actually seen a very similar report for one of
> the other CIR drivers recently. Good catch. But yeah, lets do the same for
> all the drivers, and move request_region as well.

Yeah, I've realised the other drivers had the same issue.  ite-cir was
just for one that bit us first.

Anyway, I'll be sending in a minute another patch with your comments.

Cheers,
--
Luis
