Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2APK4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 05:56:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab2APK4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 05:56:48 -0500
Date: Mon, 16 Jan 2012 08:22:02 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: SVM: comment nested paging and virtualization
 module parameters
Message-ID: <20120116102202.GC7937@amt.cnet>
References: <1326462716.3231.5.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326462716.3231.5.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 02:51:56PM +0100, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> Also use true instead of 1 for enabling by default.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/kvm/svm.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 5fa553b..3c9b0dc 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -176,11 +176,13 @@ static bool npt_enabled = true;
>  #else
>  static bool npt_enabled;
>  #endif
> -static int npt = 1;
>  
> +/* disable nested paging (virtualized MMU) for all guests */
> +static int npt = true;
>  module_param(npt, int, S_IRUGO);

Should be "allow nested paging"...

> -static int nested = 1;
> +/* allow nested virtualization in KVM/SVM */
> +static int nested = true;
>  module_param(nested, int, S_IRUGO);
>  
>  static void svm_flush_tlb(struct kvm_vcpu *vcpu);

