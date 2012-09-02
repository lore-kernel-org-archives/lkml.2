Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2IBQ3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 12:29:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab2IBQ3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 12:29:50 -0400
Message-ID: <50438978.9000405@redhat.com>
Date: Sun, 02 Sep 2012 12:29:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/1] kvm: Use vcpu_id as pivot instead of last boosted
 vcpu in PLE handler
References: <20120829192100.22412.92575.sendpatchset@codeblue> <20120902101234.GB27250@redhat.com>
In-Reply-To: <20120902101234.GB27250@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2012 06:12 AM, Gleb Natapov wrote:
> On Thu, Aug 30, 2012 at 12:51:01AM +0530, Raghavendra K T wrote:
>>   The idea of starting from next vcpu (source of yield_to + 1) seem to work
>>   well for overcomitted guest rather than using last boosted vcpu. We can also
>>   remove per VM variable with this approach.
>>
>>   Iteration for eligible candidate after this patch starts from vcpu source+1
>>   and ends at source-1 (after wrapping)
>>
>>   Thanks Nikunj for his quick verification of the patch.
>>
>>   Please let me know if this patch is interesting and makes sense.
>>
> This last_boosted_vcpu thing caused us trouble during attempt to
> implement vcpu destruction. It is good to see it removed from this POV.

I like this implementation.  It should achieve pretty much
the same as my old code, but without the downsides and without
having to keep the same amount of global state.

-- 
All rights reversed
