Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab1KGPZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:25:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283Ab1KGPZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:25:32 -0500
Message-ID: <4EB7F852.9010606@redhat.com>
Date: Mon, 07 Nov 2011 17:25:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, kvm@vger.kernel.org,
        mtosatti@redhat.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        acme@ghostprotocols.net
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
References: <1320323618-10375-1-git-send-email-gleb@redhat.com> <1320323618-10375-3-git-send-email-gleb@redhat.com> <1320676467.18053.43.camel@twins> <4EB7EF4F.3090907@redhat.com> <1320677949.18053.54.camel@twins> <4EB7F58D.6080102@redhat.com> <20111107151944.GE8670@redhat.com>
In-Reply-To: <20111107151944.GE8670@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 05:19 PM, Gleb Natapov wrote:
> > 
> > note, this needs a fairly huge PMI skew to happen.
> > 
> No, it need not. It is enough to get exit reason as hlt instead of nmi
> for a vcpu to go to blocking state instead of reentering guest mode.
> Note that we do not check request flags in kvm_arch_vcpu_runnable().

Right.

If we had a guarantee about the maximum skew, we could add a check for
KVM_REQ_PMI in kvm_vcpu_block().

-- 
error compiling committee.c: too many arguments to function

