Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab1BZF6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 00:58:38 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:45342 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1BZF6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 00:58:37 -0500
X-Originating-IP: 217.70.178.129
X-Originating-IP: 173.50.155.44
Message-ID: <4D689681.1030301@pbjtriplett.org>
Date: Fri, 25 Feb 2011 21:58:25 -0800
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Seth Forshee <seth.forshee@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
References: <20110225164239.GA24686@thinkpad-t410> <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6> <20110225212142.GC24686@thinkpad-t410> <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6> <20110225222900.GD24686@thinkpad-t410> <alpine.LFD.2.00.1102252330290.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102252330290.2701@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 02:40 PM, Thomas Gleixner wrote:
> On Fri, 25 Feb 2011, Seth Forshee wrote:
>> On Fri, Feb 25, 2011 at 10:47:16PM +0100, Thomas Gleixner wrote:
>>> Let's wait for the intel and acpi folks. It would be interesting what
>>> the new intel toy says to your BIOS.
>>>
>>>      http://biosbits.org/
>>
>> Not much because it doesn't know about my processor. About all I could
>> get out of it is that my MSRs are inconsistent, SMI latency is bad, and
>> the round-trip latency via MWAIT test gives elapsed time = 285ms with
>> 229 iterations/ms.
>
> Ouch.

Looks like the Toshiba NB305 has an Intel Atom processor in it. 
bits-327, released today, now detects Intel Atom processors, and no 
longer shows them as unknown.  We don't have any processor-specific 
tests for Atom yet, though we may add some in the future.  All of the 
general tests should work, however.

Can you provide more details on which MSRs show up as inconsistent on 
your system?  They might represent actual bugs in your BIOS, but we 
might just need to add a few more entries to the Atom CPU-specific MSR 
blacklist as expected inconsistencies.

- Burt
