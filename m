Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336Ab2FGNYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:24:53 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:58490 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756125Ab2FGNYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:24:51 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz936eIzz1202hzz8275bh8275dhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M59195-02-6F8-02
X-M-MSG: 
Date: Thu, 7 Jun 2012 15:25:05 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andre Przywara <andre.przywara@amd.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jacob Shin <jacob.shin@amd.com>, <jeremy@goop.org>,
        <xen-devel@lists.xensource.com>, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, <stable@vger.kernel.org>
Subject: [GIT PULL] x86, CPU, AMD: Cleanup AMD-specific MSR-rw users
Message-ID: <20120607132505.GG11153@aftab.osrc.amd.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <1338562358-28182-4-git-send-email-bp@amd64.org>
 <4FCFD2EE.8060508@zytor.com>
 <20120607072159.GB9856@aftab.osrc.amd.com>
 <4FD05CED.60905@amd.com>
 <20120607080833.GA23186@kroah.com>
 <4FD063F0.3060301@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FD063F0.3060301@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

so here are the final versions of the patches, as discussed. 3/4 has
lost the stable tag and all have received Konrad's Acked-by. Other than
that, 1ab46fd319bc takes care of the -stable issue for xen and Greg is
picking that one up. So all those should be queued for 3.6.

Please pull, thanks.

The following changes since commit f8f5701bdaf9134b1f90e5044a82c66324d2073f:

  Linux 3.5-rc1 (2012-06-02 18:29:26 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/amd-rdmsr-cleanups-for-3.6

for you to fetch changes up to c5214c0192813ebaa5784be36d2ae142034f84db:

  x86, CPU, AMD: Deprecate AMD-specific MSR variants (2012-06-07 12:52:58 +0200)

----------------------------------------------------------------
x86, CPU, AMD: Cleanup AMD-specific MSR-rw users

This patchset takes care of all the {rd,wr}msrl_amd_safe headaches we
had wrt xen. After it is applied, the AMD-specific variants become
private to amd.c and issue a warning when used on anything else beside
K8 because they're supposed to be used only on K8.

This also contains the two patches from Andre which cleanup the PV-side
of things.

----------------------------------------------------------------
Andre Przywara (2):
      x86, pvops: Remove hooks for {rd,wr}msr_safe_regs
      x86, AMD: Fix crash as Xen Dom0 on AMD Trinity systems

Borislav Petkov (2):
      x86, CPU: Fix show_msr MSR accessing function
      x86, CPU, AMD: Deprecate AMD-specific MSR variants

 arch/x86/include/asm/msr.h            | 42 ++---------------------------------
 arch/x86/include/asm/paravirt.h       | 39 --------------------------------
 arch/x86/include/asm/paravirt_types.h |  2 --
 arch/x86/kernel/cpu/amd.c             | 37 ++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/common.c          |  2 +-
 arch/x86/kernel/paravirt.c            |  2 --
 arch/x86/lib/msr-reg-export.c         |  4 ++--
 arch/x86/lib/msr-reg.S                | 10 ++++-----
 arch/x86/xen/enlighten.c              |  2 --
 9 files changed, 45 insertions(+), 95 deletions(-)

-- 
Regards/Gruss,
Boris.

osrc-kernel@elbe.amd.com - where all your Linux questions get answered.

Operating Systems Research Center
Advanced Micro Devices, Inc.

