Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0DSOeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 10:34:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0DSOeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 10:34:02 -0400
Message-ID: <4BCC69D5.3050209@redhat.com>
Date: Mon, 19 Apr 2010 17:33:57 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>
Subject: Re: [PATCH 1/5] Add a global synchronization point for pvclock
References: <1271356648-5108-1-git-send-email-glommer@redhat.com> <1271356648-5108-2-git-send-email-glommer@redhat.com> <4BC8CA52.4090703@goop.org> <1271673545.1674.743.camel@laptop> <4BCC3584.1050501@redhat.com> <1271675100.1674.818.camel@laptop> <4BCC3A3E.9070909@redhat.com> <20100419142158.GD14158@mothafucka.localdomain>
In-Reply-To: <20100419142158.GD14158@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 05:21 PM, Glauber Costa wrote:
>
>> Oh yes, just trying to avoid a patch with both atomic64_read() and
>> ACCESS_ONCE().
>>      
> you're mixing the private version of the patch you saw with this one.
> there isn't any atomic reads in here. I'll use a barrier then
>    

This patch writes last_value atomically, but reads it non-atomically.  A 
barrier is insufficient.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

