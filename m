Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424Ab1CIV3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:29:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab1CIV3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:29:50 -0500
Message-ID: <4D77F149.8020906@redhat.com>
Date: Wed, 09 Mar 2011 16:29:45 -0500
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Nikola Ciprich <extmaillist@linuxbox.cz>
CC: KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>,
        nikola.ciprich@linuxbox.cz, Avi Kivity <avi@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: Re: [PATCH] add missing guest clock update removed by	e48672fa25e879f7ae21785c7efd187738139593
References: <20110307101827.GA1762@pcnci.linuxbox.cz> <4D768A62.3050903@redhat.com> <20110309193003.GB1762@pcnci.linuxbox.cz>
In-Reply-To: <20110309193003.GB1762@pcnci.linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 02:30 PM, Nikola Ciprich wrote:
>> Can you try moving the kvm_make_request() inside the if conditional and
>> see if it that also fixes it?
>>      
> yes, changing to:
> if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
> 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> 	/* Make sure TSC doesn't go backwards */
> 	s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
>
> is also OK.
>
> what about changing:
> if (check_tsc_unstable()) {
> 	kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
> 	vcpu->arch.tsc_catchup = 1;
> 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
> }
>
> to:
>
> if (check_tsc_unstable()) {
> 	kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
> 	vcpu->arch.tsc_catchup = 1;
> }
> kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
>
> this fixes thinks for me as well..
> n.
> ?
>    

Can you send a patch which does that?  I think this is the correct fix.

Thanks,

Zach
