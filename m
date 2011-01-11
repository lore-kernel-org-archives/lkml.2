Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1AKQAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:00:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47882 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932275Ab1AKQAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:00:34 -0500
Date: Tue, 11 Jan 2011 15:59:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rabin Vincent <rabin@rab.in>
Cc: Alexander Holler <holler@ahsoftware.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: Re: ARM: relocation out of range (when loading a module)
Message-ID: <20110111155930.GH11039@n2100.arm.linux.org.uk>
References: <4D2B4CE4.9080309@ahsoftware.de> <alpine.LFD.2.00.1101101722470.9794@xanadu.home> <4D2BFA08.5030104@ahsoftware.de> <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinR7ih2ZMRMbXmSvoh-rS3LVv+UCvd0rRH_ESzf@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 09:16:38PM +0530, Rabin Vincent wrote:
> It's possible to hack around this by placing the initramfs at the end of
> the kernel image rather than at the beginning with the rest of the init
> data.  Something like the below should work, although you should also
> probably take care of alignment and also have this section freed when
> the rest of the init data is freed.

You're then running into problems as _sdata.._edata is copied to RAM on
XIP kernels, and you really don't want to waste time copying the
initramfs to RAM.
