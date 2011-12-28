Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1L1KSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 05:18:09 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:57708 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1L1KSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 05:18:08 -0500
Message-ID: <4EFAED2E.6090403@oss.ntt.co.jp>
Date: Wed, 28 Dec 2011 19:19:26 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Liu Ping Fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, gleb@redhat.com,
        mtosatti@redhat.com, xiaoguangrong.eric@gmail.com, jan.kiszka@web.de,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Subject: Re: [PATCH v6] kvm: make vcpu life cycle separated from kvm instance
References: <1324091975-20930-1-git-send-email-kernelfans@gmail.com> <1324975139-8836-1-git-send-email-kernelfans@gmail.com> <4EFAE72D.3080609@redhat.com> <4EFAE74F.7000200@redhat.com>
In-Reply-To: <4EFAE74F.7000200@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/12/28 18:54), Avi Kivity wrote:
> On 12/28/2011 11:53 AM, Avi Kivity wrote:
>> On 12/27/2011 10:38 AM, Liu Ping Fan wrote:
>>> From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>>>
>>> Currently, vcpu can be destructed only when kvm instance destroyed.
>>> Change this to vcpu's destruction before kvm instance, so vcpu MUST
>>> and CAN be destroyed before kvm's destroy.
>>>
>>> Signed-off-by: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>>> ---
>>>   arch/x86/kvm/i8254.c     |   10 +++--
>>>   arch/x86/kvm/i8259.c     |   17 +++++--
>>>   arch/x86/kvm/x86.c       |   53 +++++++++++-----------
>>>   include/linux/kvm_host.h |   20 +++-----
>>>   virt/kvm/irq_comm.c      |    6 ++-
>>>   virt/kvm/kvm_main.c      |  110 +++++++++++++++++++++++++++++++++++-----------
>>>
>>
>> Documentation/virtual/kvm/api.txt
>>
>
> Oops, that's only needed when the unplug API is introduced.
>

I think it is OK to to add such an API later on, but I really want
the author to write the plan in the changelog.

Otherwise people not belonging to Red Hat or IBM cannot know what
this commit is aiming at.

I am not objecting to this patch itself, but the way this kind of change
is being introduced seems not be in a good manner.

	Takuya
