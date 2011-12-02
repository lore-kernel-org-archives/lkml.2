Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1LBIx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 03:53:26 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:52507
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752685Ab1LBIxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 03:53:24 -0500
X-SpamScore: -25
X-BigFish: VPS-25(zz179dN1432N98dKzz1202hzz15d4R8275bh8275dhz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LVKJCQ-02-8RY-02
X-M-MSG: 
Date: Fri, 2 Dec 2011 09:53:16 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sasha Levin <levinsasha928@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: SVM: Notify if SVM is already in use
Message-ID: <20111202085316.GI13268@amd.com>
References: <1322764218-4698-1-git-send-email-levinsasha928@gmail.com>
 <1322764218-4698-2-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322764218-4698-2-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 08:30:18PM +0200, Sasha Levin wrote:
> Currently we silently fail if SVM is already in use by a different
> virtualization technology.
> 
> This is bad since it's non-obvious for the user, and its not too uncommon
> for users to have several of these installed on same host.
> 
> This patch adds a message to notify the user of the problem.
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  arch/x86/kvm/svm.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e32243e..8d1a066 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -587,8 +587,11 @@ static int svm_hardware_enable(void *garbage)
>  	int me = raw_smp_processor_id();
>  
>  	rdmsrl(MSR_EFER, efer);
> -	if (efer & EFER_SVME)
> +	if (efer & EFER_SVME) {
> +		printk(KERN_ERR "svm_hardware_enable: SVM already in use on CPU%d. "
> +				"Are you already another hypervisor?\n", me);

Hmm, this can nicely flood dmesg on a machine with many cores :) How
about removing the CPU%d part of the message and using printk_once?


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

