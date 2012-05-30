Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2E3PFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 11:05:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40055 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab2E3PFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 11:05:22 -0400
Date: Wed, 30 May 2012 17:05:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andre Przywara <andre.przywara@amd.com>, mingo@elte.hu, tglx@linutronix.de,
        konrad.wilk@oracle.com, jeremy@goop.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, stable@vger.kernel.org
Subject: Re: [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity systems
Message-ID: <20120530150520.GC15438@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andre Przywara <andre.przywara@amd.com>, mingo@elte.hu,
	tglx@linutronix.de, konrad.wilk@oracle.com, jeremy@goop.org,
	linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
	stable@vger.kernel.org
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC631D3.9080907@zytor.com>
 <20120530145523.GA15635@x1.osrc.amd.com>
 <4FC6358F.2010405@zytor.com>
 <20120530150007.GB15438@x1.osrc.amd.com>
 <4FC6363F.3040208@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC6363F.3040208@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 08:01:19AM -0700, H. Peter Anvin wrote:
> >> I'm not following: If the AMD variants (putting a special value into
> >> %edi) can be freely replaced by the non-AMD variants, why did
> >> the AMD special ones get used in the first place?
> 
> > Older CPUs (K8) needed the AMD variants, starting with family 10h we
> > can use the normal versions.
> 
> So no, not correct.

I don't see what the problem is: the amd* variants shouldn't have been
used at all in the first place. Fullstop. The patch should've been doing
*msrl_safe from the get-go. Regardless of family.

So what's the issue?

-- 
Regards/Gruss,
Boris.
