Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1GNIQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:16:39 -0400
Received: from sous-sol.org ([216.99.217.87]:59508 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752882Ab1GNIQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:16:36 -0400
Date: Thu, 14 Jul 2011 01:16:19 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH resend] pci: ARI is a PCIe v2 feature
Message-ID: <20110714081619.GB15844@sequoia.sous-sol.org>
References: <20110713171433.GU15844@sequoia.sous-sol.org>
 <20110714153533.7f310cdf@jbarnes-e6510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714153533.7f310cdf@jbarnes-e6510>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jesse Barnes (jbarnes@virtuousgeek.org) wrote:
> On Wed, 13 Jul 2011 10:14:33 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > The function pci_enable_ari() may mistakenly set the downstream port
> > of a v1 PCIe switch in ARI Forwarding mode.  This is a PCIe v2
> > feature, and with an SR-IOV device on that switch port believing the
> > switch above is ARI capable it may attempt to use functions 8-255,
> > translating into invalid (non-zero) device numbers for that bus.
> > This has been seen to cause Completion Timeouts and general
> > misbehaviour including hangs and panics.
> 
> Thanks Chris, your earlier one is still sitting in my queue, but I
> wasn't going to send it for 3.0 as it didn't seem that critical.  Do
> you think it is?  If so you can send it directly to Linus with my ack
> as I don't have anything else queued, or just wait until the merge
> window when it will be put into the stable tree as well.

Cool, just wanted to make sure it wasn't lost.  I think it's fine to
merge in next window and let it filter back to -stable.  While I've seen
it cause panics, it's not a regression and the conditions required are
very specific (possibly including buggy BIOS).

thanks,
-chris
