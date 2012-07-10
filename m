Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2GJL4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:56:01 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40475 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252Ab2GJLz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:55:59 -0400
Message-ID: <4FFC17D8.5010108@linux.vnet.ibm.com>
Date: Tue, 10 Jul 2012 17:24:00 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: habanero@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
        S390 <linux-s390@vger.kernel.org>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 <x86@kernel.org>,
        Gleb Natapov <gleb@redhat.com>, linux390@de.ibm.com,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH RFC 0/2] kvm: Improving directed yield in PLE handler
References: <20120709062012.24030.37154.sendpatchset@codeblue> <1341870457.2909.27.camel@oc2024037011.ibm.com>
In-Reply-To: <1341870457.2909.27.camel@oc2024037011.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12071001-1396-0000-0000-00000189863A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 03:17 AM, Andrew Theurer wrote:
> On Mon, 2012-07-09 at 11:50 +0530, Raghavendra K T wrote:
>> Currently Pause Looop Exit (PLE) handler is doing directed yield to a
>> random VCPU on PL exit. Though we already have filtering while choosing
>> the candidate to yield_to, we can do better.
>
> Hi, Raghu.
>
[...]
>
> Can you briefly explain the 1x and 2x configs?  This of course is highly
> dependent whether or not HT is enabled...
>

Sorry if I had not made very clear in earlier threads. Have you applied
Rik's following patch for base. without this you could see some 
inconsistent results perhaps.

https://lkml.org/lkml/2012/6/19/401

