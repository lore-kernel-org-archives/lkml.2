Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369Ab0DLOhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 10:37:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43982 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab0DLOhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 10:37:51 -0400
Message-ID: <4BC33022.3000608@zytor.com>
Date: Mon, 12 Apr 2010 07:37:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Colin King <colin.king@canonical.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Disable 4MB page tables for Atom, work around errata
 AAE44
References: <1269271251-19775-1-git-send-email-colin.king@canonical.com> <87633xayk4.fsf@basil.nowhere.org>
In-Reply-To: <87633xayk4.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 01:02 AM, Andi Kleen wrote:
> Colin King <colin.king@canonical.com> writes:
>>  
>> +static void __init check_atom(void)
>> +{
>> +
>> +	/*
>> +	 *  Disable 4MB page tables to work around Intel errata AAE44 for
>> +	 *  Atom. We cannot guarantee stopping undefined processor behaviour
>> +	 *  when two pageing structure translations differ with respect to
>> +	 *  page frame sizes.  Hence, for Atoms we disable the PSE.
>> +	 */
>> +	if (boot_cpu_data.x86_model == 0x1c) {
> 
> Perhaps someone else pointed that out already, but you obviously
> need to check for x86_vendor == X86_VENDOR_INTEL and x86_family == 6 too,
> otherwise you'll get false positives.
> 
> Besides such workarounds are normally in arch/x86/kernel/cpu/intel.c.
> bugs.c is really obsolete.
> 

Much more than that, the constraint is clearly not strict enough.  I'm
currently trying to work out internally what the actual constraint
should be (it's a bit of a documentation hole at the moment.)

	-hpa

