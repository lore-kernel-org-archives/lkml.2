Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab0D1Lgp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 07:36:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab0D1Lgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 07:36:43 -0400
Message-ID: <4BD8046F.3000406@redhat.com>
Date: Wed, 28 Apr 2010 12:48:31 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the final tree
References: <20100427154917.405e21df.sfr@canb.auug.org.au> <DB60B93C-DFAC-4D99-8E3C-364DAF433A07@suse.de>
In-Reply-To: <DB60B93C-DFAC-4D99-8E3C-364DAF433A07@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2010 12:41 PM, Alexander Graf wrote:
>
> Am 27.04.2010 um 06:49 schrieb Stephen Rothwell <sfr@canb.auug.org.au>:
>
>> Hi all,
>>
>> After merging the final tree, today's linux-next build (powerpc
>> allyesconfig) failed like this:
>>
>> arch/powerpc/kvm/book3s.c: In function 'kvmppc_core_vcpu_create':
>> arch/powerpc/kvm/book3s.c:1241: error: implicit declaration of 
>> function 'kzalloc'
>> arch/powerpc/kvm/book3s.c:1241: warning: cast to pointer from integer 
>> of different size
>> arch/powerpc/kvm/book3s.c:1281: error: implicit declaration of 
>> function 'kfree'
>>
>> Caused by commit 046cdc052ffcbf1ee1c627ef811031d18654bafe ("KVM: PPC:
>> Improve indirect svcpu accessors") from the kvm tree.
>>
>> You have to include slab.h directly to use kzalloc/kfree ...
>>
>> I have applied the following patch for today.
>
> Thank you. Is that behavior new? I didn't get any breakage when 
> compile testing myself.

Probably .config dependent.

> Will this commit automatically move back to kvm.git or is there any 
> intervention required from my side?

Marcelo or me need to apply it.

-- 
error compiling committee.c: too many arguments to function

