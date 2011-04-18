Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1DRTGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 15:06:24 -0400
Received: from 8bytes.org ([88.198.83.132]:50004 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab1DRTGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 15:06:21 -0400
Date: Mon, 18 Apr 2011 21:06:20 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Roedel, Joerg" <Joerg.Roedel@amd.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 1/4] x86, gart: Don't enforce GART aperture lower-bound
	by alignment
Message-ID: <20110418190620.GD8155@8bytes.org>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com> <1303134346-5805-2-git-send-email-joerg.roedel@amd.com> <4DAC4E7F.1010502@zytor.com> <20110418145653.GI2192@amd.com> <4DAC5E16.1020408@zytor.com> <20110418173655.GA8155@8bytes.org> <4DAC7739.2060100@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAC7739.2060100@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:39:05AM -0700, H. Peter Anvin wrote:
> I'm going to apply your patch as-is, based on the notion that this is a
> change of mechanism, and a change of policy is a separate thing.
> However, we should address the shutdown of the GART first, and then we
> can move the start address to zero (again, two separate patches.)

Hmm, thinking again about this, setting the lower-bound to 0 may break
kdump setups. The kdump kernel is then able to allocate an aperture too
and that may use half of the memory from the kdump-system so that the
dump-process triggers OOM.
As it is now, the GART is automatically disabled when the BIOS doesn't
setup it correctly and the machine has not more than 512MB of memory.
Either we keep it as is or, with the changes suggested above, we handle
it like soft-iotlb and don't use gart for dma-api at all when
max_pfn is smaller than 4G.

	Joerg

