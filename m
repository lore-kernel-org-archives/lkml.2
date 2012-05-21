Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab2EUIVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 04:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505Ab2EUIVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 04:21:38 -0400
Message-ID: <4FB9FAFD.80106@redhat.com>
Date: Mon, 21 May 2012 11:21:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xudong Hao <xudong.hao@intel.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        takuya.yoshikawa@gmail.com, xiantao.zhang@intel.com,
        Haitao Shan <haitao.shan@intel.com>
Subject: Re: [PATCH v2 4/4] Enabling Access bit when doing memory swapping
References: <1337572443-22482-1-git-send-email-xudong.hao@intel.com> <1337572443-22482-4-git-send-email-xudong.hao@intel.com>
In-Reply-To: <1337572443-22482-4-git-send-email-xudong.hao@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 06:54 AM, Xudong Hao wrote:
> Enabling Access bit when doing memory swapping.
>
> @@ -1243,11 +1244,11 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
>  
>  	for (sptep = rmap_get_first(*rmapp, &iter); sptep;
>  	     sptep = rmap_get_next(&iter)) {
> -		BUG_ON(!(*sptep & PT_PRESENT_MASK));
> +		BUG_ON(!is_shadow_present_pte(*sptep));
>  
> -		if (*sptep & PT_ACCESSED_MASK) {
> +		if (*sptep & shadow_accessed_mask) {
>  			young = 1;
> -			clear_bit(PT_ACCESSED_SHIFT, (unsigned long *)sptep);
> +			*sptep &= ~shadow_accessed_mask;
>  		}
>  	}

As Marcelo already noted, this converts an atomic operation into a
non-atomic one.


-- 
error compiling committee.c: too many arguments to function

