Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2E3Oz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:55:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34439 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754192Ab2E3Oz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:55:26 -0400
Date: Wed, 30 May 2012 16:55:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andre Przywara <andre.przywara@amd.com>, mingo@elte.hu, tglx@linutronix.de,
        konrad.wilk@oracle.com, jeremy@goop.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, stable@vger.kernel.org.#.3.4+
Subject: Re: [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity systems
Message-ID: <20120530145523.GA15635@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andre Przywara <andre.przywara@amd.com>, mingo@elte.hu,
	tglx@linutronix.de, konrad.wilk@oracle.com, jeremy@goop.org,
	linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
	stable@vger.kernel.org.#.3.4+
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com>
 <4FC631D3.9080907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FC631D3.9080907@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 07:42:27AM -0700, H. Peter Anvin wrote:
> On 05/30/2012 06:10 AM, Andre Przywara wrote:
> > Because we are behind a family check before tweaking the topology
> > bit, we can use the standard rd/wrmsr variants for the CPUID feature
> > register.
> 
> That is not what the *msr*_amd*() functions do.
> 
> NAK.  This is a totally bogus patch.

The *msr*_amd*() variants were used instead of the normal *msrl_safe
variants although the AMD variants weren't needed there at all.

This has no issue on baremetal but breaks xen and this is how we caught
this.

So the patch corrects the original patch so that xen is happy too.

-- 
Regards/Gruss,
Boris.
