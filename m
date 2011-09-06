Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1IFOhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:37:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab1IFOh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:37:29 -0400
Subject: Re: [PATCH 2/3] define ARM-specific dma_coherent_write_sync
From: Mark Salter <msalter@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ming.lei@canonical.com, stern@rowland.harvard.edu
Date: Tue, 06 Sep 2011 10:37:15 -0400
In-Reply-To: <CAHkRjk7ZMDQh8sYf7N_4LLS12JU2ps8dkC34gNWNH+-Zp0p8Rg@mail.gmail.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
	 <1314826214-22428-3-git-send-email-msalter@redhat.com>
	 <CAHkRjk7ZMDQh8sYf7N_4LLS12JU2ps8dkC34gNWNH+-Zp0p8Rg@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1315319837.2313.1.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-06 at 15:32 +0100, Catalin Marinas wrote:
> That's what mb() and wmb() do already, at least on ARM. Why do we need
> another API? IIRC from past discussions on linux-arch around barriers,
> the mb() should be sufficient in the case of DMA coherent buffers.
> That's why macros like writel() on ARM have the mb() added by default
> (for cases where you start the DMA transfer by writing to a device
> register). 

For USB EHCI, the driver does not necessarily write to a register after
writing to DMA coherent memory. In some cases, the controller polls for
information written by the driver.

--Mark


