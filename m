Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab2HAIll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 04:41:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2HAIli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:41:38 -0400
Message-ID: <5018EBAF.9090404@redhat.com>
Date: Wed, 01 Aug 2012 11:41:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [RFC PATCH] KVM: Only print vcpu_unimpl when DEBUG is set
References: <20120726122248.GA252@x4> <20120801031930.GB31711@amt.cnet>
In-Reply-To: <20120801031930.GB31711@amt.cnet>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 06:19 AM, Marcelo Tosatti wrote:
> On Thu, Jul 26, 2012 at 02:22:48PM +0200, Markus Trippelsdorf wrote:
>> Every time I start qemu-kvm on my system the following line is added to
>> the syslog:
>> 
>>  vcpu0 unhandled rdmsr: 0xc0010001
>> 
>> AFAICS all calls to vcpu_unimpl only contain debugging info with little
>> or no value for the end user.
>> 
>> Wouldn't something like the following patch make sense?
>> 
>> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> 
> It could be useful for debugging (but then lots of other things could).
> 
> Anyone has a use for this?

The current scenario is:

<guest breaks>
Maintainer asks for dmesg
If something shows up, it's something to consider

Following this patch, the scenario will be

<guest breaks>
Maintainer: please enable dynamic debug for kvm and reproduce
If something shows up, it's something to consider

I guess with dynamic debug it's acceptable, we just need to make sure
that it doesn't spew tons of other stuff.

-- 
error compiling committee.c: too many arguments to function


