Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2IDQRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 12:17:05 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41634 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab2IDQRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 12:17:01 -0400
Date: Tue, 4 Sep 2012 17:16:58 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 03/11] x86: Lock down IO port access in secure boot
 environments
Message-ID: <20120904161658.GA23177@srcf.ucam.org>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-4-git-send-email-mjg@redhat.com>
 <20120904171603.3ccb5891@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904171603.3ccb5891@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 05:16:03PM +0100, Alan Cox wrote:
> On Tue,  4 Sep 2012 11:55:09 -0400
> Matthew Garrett <mjg@redhat.com> wrote:
> 
> > IO port access would permit users to gain access to PCI configuration
> > registers, which in turn (on a lot of hardware) give access to MMIO register
> > space. This would potentially permit root to trigger arbitrary DMA, so lock
> > it down by default.
> 
> You've missed a load of others, all over the kernel, let alone getting
> into devices with other paths to firmware reprogramming of which there
> are many.
> 
> You need to enforce signing on request_firmware for example, and sign
> every firmware.

Sure, but that's going to depend on the module signing code which hasn't 
landed yet. But for the most part, devices that are designed for these 
platforms will only accept signed firmware at the device level.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
