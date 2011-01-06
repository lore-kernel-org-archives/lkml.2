Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1AFL1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 06:27:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1AFL1S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 06:27:18 -0500
Message-ID: <4D25A710.5030500@redhat.com>
Date: Thu, 06 Jan 2011 01:27:12 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [KVM TSC trapping / migration 2/2] Add TSC KHZ MSR
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com> <1294308645-31113-3-git-send-email-zamsden@redhat.com> <F57C0733-9A1A-4A6D-9D62-39B836559878@suse.de>
In-Reply-To: <F57C0733-9A1A-4A6D-9D62-39B836559878@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2011 12:34 AM, Alexander Graf wrote:
> Am 06.01.2011 um 11:10 schrieb Zachary Amsden<zamsden@redhat.com>:
>
>    
>> Use an MSR to allow "soft" migration to hosts which do not support
>> TSC trapping.  Rather than make this a required element of any
>> migration protocol, we allow the TSC rate to be exported as a data
>> field (useful in its own right), but we also allow a one time write
>> of the MSR during VM creation.  The result is that for the common
>> use case, no protocol change is required to communicate TSC rate
>> to the receiving host.
>>
>> This allows administrative tools to configure migration policy
>> as they see appropriate.  Rather than dictate this policy with the
>> KVM implementation, we properly allow migration to hosts which both
>> do and do not support setting of the TSC rate on the receiving end.
>> If it is wished to not support migration to a host which lacks
>> support for the TSC rate feature, that can be coordinated externally.
>>      
> Isn't there a real hw equivalent of such a register? It might make more sense to just implement that then.
>
>    

Unfortunately, no.
