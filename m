Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0LCOQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 09:16:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab0LCOQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 09:16:35 -0500
Message-ID: <4CF8FBAA.7000807@redhat.com>
Date: Fri, 03 Dec 2010 09:16:10 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: vatsa@linux.vnet.ibm.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 1/3] kvm: keep track of which task is running a KVM
 vcpu
References: <20101202144129.4357fe00@annuminas.surriel.com> <20101202144324.4a79263b@annuminas.surriel.com> <20101203121746.GE27994@linux.vnet.ibm.com>
In-Reply-To: <20101203121746.GE27994@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2010 07:17 AM, Srivatsa Vaddagiri wrote:
> On Thu, Dec 02, 2010 at 02:43:24PM -0500, Rik van Riel wrote:
>>   	mutex_lock(&vcpu->mutex);
>> +	vcpu->task = current;
>
> Shouldn't we grab reference to current task_struct before storing a pointer to
> it?

That should not be needed, since current cannot go away without
setting vcpu->task back to NULL in vcpu_put.

-- 
All rights reversed
