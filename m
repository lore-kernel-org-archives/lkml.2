Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894Ab0J2OQH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:16:07 -0400
Received: from claw.goop.org ([74.207.240.146]:51623 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933875Ab0J2OQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:16:05 -0400
Message-ID: <4CCAD722.3040004@goop.org>
Date: Fri, 29 Oct 2010 07:16:02 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Teck Choon Giam <giamteckchoon@gmail.com>
Subject: Re: Section conflicts with percpu variables
References: <4CC8780C.8090401@goop.org> <4CC9409D.7050405@kernel.org>
In-Reply-To: <4CC9409D.7050405@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/28/2010 02:21 AM, Tejun Heo wrote:
> On 10/27/2010 09:05 PM, Jeremy Fitzhardinge wrote:
>>  Hi Tejun,
>>
>> I wonder if you could have a look at this.  I have someone reporting
>> compilation failures when using the stock Centos 5 compiler:
>>
>> arch/x86/xen/mmu.c:163: error: __pcpu_scope_xen_cr3 causes a section type conflict
>> arch/x86/xen/mmu.c:164: error: __pcpu_scope_xen_current_cr3 causes a section type conflict
>> arch/x86/xen/mmu.c:163: error: __pcpu_unique_xen_cr3 causes a section type conflict
>> arch/x86/xen/mmu.c:164: error: __pcpu_unique_xen_current_cr3 causes a section type conflict
>>
>> Looking at mmu.i, I can't see why it is picking on these particular
>> per-cpu variables.  Do you have any insight into this.
> Hmmm... me neither.  section type conflict?  Does it make any
> different if you move the definitions near the top of the file or use
> a different compiler version?

This is the first report of this kind I've seen, so it mostly works. 
The compiler in question is the stock Centos 5 (.1?) compiler, so it
would be nice to make sure it works as-is.

I've seen section type conflicts with .discard before when discarding a
function and a data type with the same section, which is why I added
general support for .discard.* so they can all get their own sections. 
But that doesn't seem to be the case here.

    J
