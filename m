Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0LENAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 08:00:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab0LENAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 08:00:14 -0500
Message-ID: <4CFB8CC5.50902@redhat.com>
Date: Sun, 05 Dec 2010 14:59:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: vatsa@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144324.4a79263b@annuminas.surriel.com> <20101203121746.GE27994@linux.vnet.ibm.com> <4CF8FBAA.7000807@redhat.com>
In-Reply-To: <4CF8FBAA.7000807@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 04:16 PM, Rik van Riel wrote:
> On 12/03/2010 07:17 AM, Srivatsa Vaddagiri wrote:
>> On Thu, Dec 02, 2010 at 02:43:24PM -0500, Rik van Riel wrote:
>>>       mutex_lock(&vcpu->mutex);
>>> +    vcpu->task = current;
>>
>> Shouldn't we grab reference to current task_struct before storing a 
>> pointer to
>> it?
>
> That should not be needed, since current cannot go away without
> setting vcpu->task back to NULL in vcpu_put.
>

However, you do reference vcpu->task from other contexts.  So some sort 
of safe reference is needed.

-- 
error compiling committee.c: too many arguments to function

