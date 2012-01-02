Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2ABI7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 03:59:00 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:13593 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2ABI65 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 2 Jan 2012 03:58:57 -0500
Message-Id: <4F018015020000780006A015@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 02 Jan 2012 08:59:49 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Christoph Lameter" <cl@linux.com>
Cc: <mingo@elte.hu>, <linux-kernel@vger.kernel.org>
Subject: Re: irqsafe_cpu_...() 64-bit operations on 32-bit platform
References: <4EF4581C0200007800069BA2@nat28.tlf.novell.com>
 <alpine.DEB.2.00.1112230908550.1691@router.home>
In-Reply-To: <alpine.DEB.2.00.1112230908550.1691@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.12.11 at 16:13, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 23 Dec 2011, Jan Beulich wrote:
> 
>> you introduced these for 2.6.33, but I wonder about their completeness
> 
>> in the current state: On ix86, I can add, sub, xor, etc a 64-bit variable
>> this way (through the generic implementation), but there's no way to
>> read or write such a variable. While not documented explicitly, it seems
>> like the assumption is that this_cpu_{read,write}() can be used for this
>> purpose, but that's clearly wrong.
> 
> Hmmm... We could add those but then you would usually not assign the
> initial values in a situation where concurrency is an issue. Typically you 
> would have
> a loop over all possible cpus and then simply do a 64 bit assign to the 64
> bit values address determined via per_cpu_ptr().

You seem to assume that these would be used solely for statistical
values, but maintaining last seen values (e.g. obtained from an
underlying hypervisor) is just one other use.

> And yes reading could be an issue if you have concurrent updates ongoing.
> 
> However, if you are using a loop to sum up all counters from every
> processor then you cannot use the this_cpu ops but would have to use
> something like get_64().

I understand that, but again statistics aren't my focus here.

> Reliably reading a 64 bit value on 32 bit may
> strangely require a write operation via cmpxchg8b.

Correct, but it would appear to be a read even to the compiler (only
the actual assembly implementation would have to know that it's
really a write).

Jan

