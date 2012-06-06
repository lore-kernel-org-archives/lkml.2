Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978Ab2FFWBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:01:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43137 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752170Ab2FFWBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:01:06 -0400
Message-ID: <4FCFD2EE.8060508@zytor.com>
Date: Wed, 06 Jun 2012 15:00:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        stable@vger.kernel.org.#.3.4+,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/4] x86, AMD: Fix crash as Xen Dom0 on AMD Trinity systems
References: <1338562358-28182-1-git-send-email-bp@amd64.org> <1338562358-28182-4-git-send-email-bp@amd64.org>
In-Reply-To: <1338562358-28182-4-git-send-email-bp@amd64.org>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2012 07:52 AM, Borislav Petkov wrote:
> From: Andre Przywara <andre.przywara@amd.com>
> 
> f7f286a910221 ("x86/amd: Re-enable CPU topology extensions in case BIOS
> has disabled it") wrongfully added code which used the AMD-specific
> {rd,wr}msr variants for no real reason.
> 
> This caused boot panics on xen which wasn't initializing the
> {rd,wr}msr_safe_regs pv_ops members properly.
> 
> This, in turn, caused a heated discussion leading to us reviewing all
> uses of the AMD-specific variants and removing them where unneeded
> (almost everywhere except an obscure K8 BIOS fix, see 6b0f43ddfa358).
> 
> Finally, this patch switches to the standard {rd,wr}msr*_safe* variants
> which should've been used in the first place anyway and avoided unneeded
> excitation with xen.
> 
> Signed-off-by: Andre Przywara <andre.przywara@amd.com>
> Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> Cc: stable@vger.kernel.org # 3.4+
> Link: <http://lkml.kernel.org/r/1338383402-3838-1-git-send-email-andre.przywara@amd.com>
> [Boris: correct and expand commit message]
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

Why -stable?  I though we had agreed that we didn't have an active
problem (unclean hack, yes, but not an active problem) in 3.4/3.5 as it
currently sits?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

