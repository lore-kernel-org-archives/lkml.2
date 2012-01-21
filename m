Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab2AURcM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 12:32:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:34955 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2AURcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 12:32:10 -0500
Date: Sat, 21 Jan 2012 18:32:07 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Robert Morell <rmorell@nvidia.com>
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>
Subject: Re: [PATCH] dma-buf: Use EXPORT_SYMBOL
Message-ID: <20120121173207.GF3821@phenom.ffwll.local>
Mail-Followup-To: Robert Morell <rmorell@nvidia.com>,
	"Semwal, Sumit" <sumit.semwal@ti.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"sumit.semwal@linaro.org" <sumit.semwal@linaro.org>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
 <1326845297-6233-1-git-send-email-rmorell@nvidia.com>
 <1326845297-6233-2-git-send-email-rmorell@nvidia.com>
 <CAB2ybb-RF_JU=pFDM01PJ8kiCMrJkXAMCk2LcVqYUtEoJ_We2g@mail.gmail.com>
 <20120120180457.GE29824@morell.nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20120120180457.GE29824@morell.nvidia.com>
X-Operating-System: Linux phenom 3.2.0-rc6+
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 10:04:57AM -0800, Robert Morell wrote:
> On Wed, Jan 18, 2012 at 01:10:04AM -0800, Semwal, Sumit wrote:
> > On Wed, Jan 18, 2012 at 5:38 AM, Robert Morell <rmorell@nvidia.com> wrote:
> > > EXPORT_SYMBOL_GPL is intended to be used for "an internal implementation
> > > issue, and not really an interface".  The dma-buf infrastructure is
> > > explicitly intended as an interface between modules/drivers, so it
> > > should use EXPORT_SYMBOL instead.
> > 
> > + Konrad, Arnd, Mauro: there were strong objections on using
> > EXPORT_SYMBOL in place of EXPORT_SYMBOL_GPL by all 3 of them; I
> > suggest we first arrive at a consensus before merging this patch.
> 
> This discussion seems to have stagnated; how do we move forward here?
> 
> Sumit, as the primary author and new maintainer (congrats!) of the
> dma-buf infrastructure, it seems like it's really your call how to
> proceed.  I'd still like to see this be something that we can use from
> the nvidia and fglrx drivers for Xorg buffer sharing, as I and Dave have
> argued in this thread.  It really seems to me that this change on a
> technical level won't have any adverse effect on the scenarios where it
> can be used today, but it will allow it to be used more widely, which
> will prevent duplication and fragmentation in the future and be greatly
> appreciated by users of hardware such as Optimus.

Given that I've participated quite a bit in the design of dma_buf as-is,
let me throw in my totally irrelevant opinion, too ;-)

I'll refrain from comment on the actual patch, it's obviously a hot topic.
Furthermore I might need to ask Intel's legal dep for guidance to asses
things wrt my own contributions to dma_buf.

Otoh I'd like nvidia to be on board, especially when we're desingned
additions to dma_buf required to make it really work for multiple gpus. In
additions it looks like that the nvidia blob will only be an importer of a
dma_buf, at least for the use-cases discussed here.

So why don't you just ditch this patch here and add a small shim to your
blob to interface with drm's prime as an importing driver? I personally
would deem that acceptable and I think Dave wouldn't mind too much,
either.

Yours, Daniel

Disclaimer: This is my own opinion and I do not speak as an Intel employee
here.
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
