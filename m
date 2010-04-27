Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0D0Nkn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 09:40:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab0D0Nkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 09:40:41 -0400
Message-ID: <4BD6E956.7070005@redhat.com>
Date: Tue, 27 Apr 2010 16:40:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] KVM: X86: Add kvm_read_guest_page_tdp function
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com> <1272364712-17425-14-git-send-email-joerg.roedel@amd.com> <4BD6DBB3.7050908@redhat.com>
In-Reply-To: <4BD6DBB3.7050908@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2010 03:42 PM, Avi Kivity wrote:
>
>> +{
>> +    gfn_t real_gfn;
>> +    gpa_t gpa;
>> +
>> +    *error   = 0;
>> +    gpa      = gfn<<  PAGE_SHIFT;

This overflows too :)

Use gfn_to_gpa().

>> +    real_gfn = mmu->translate_gpa(vcpu, gpa, error);
>
> Overflow: sizeof(gpa) > sizeof(gfn).

-- 
error compiling committee.c: too many arguments to function

