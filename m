Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964924Ab2FAPgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:36:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42794 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952Ab2FAPgf convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:15:2>);
	Fri, 1 Jun 2012 11:36:35 -0400
Message-Id: <4FC8FD9C0200007800087DF5@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 01 Jun 2012 16:36:28 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Russell King" <linux@arm.linux.org.uk>, <yong.zhang0@gmail.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>, <peterz@infradead.org>,
        <mingo@kernel.org>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <akpm@linux-foundation.org>,
        <nikunj@linux.vnet.ibm.com>, <paulmck@linux.vnet.ibm.com>,
        <vatsa@linux.vnet.ibm.com>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "Ingo Molnar" <mingo@redhat.com>, <rusty@rustcorp.com.au>,
        <rjw@sisk.pl>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Keir Fraser" <keir@xen.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 05/27] xen, cpu hotplug: Don't call
 cpu_bringup() in xen_play_dead()
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
 <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com>
 <4FC8D8E30200007800087D2B@nat28.tlf.novell.com>
 <4FC8DC19.4000007@linux.vnet.ibm.com>
In-Reply-To: <4FC8DC19.4000007@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.06.12 at 17:13, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
wrote:
> On 06/01/2012 06:29 PM, Jan Beulich wrote:
> 
>>>>> On 01.06.12 at 11:11, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>> wrote:
>>> xen_play_dead calls cpu_bringup() which looks weird, because xen_play_dead()
>>> is invoked in the cpu down path, whereas cpu_bringup() (as the name 
>>> suggests) is useful in the cpu bringup path.
>> 
>> This might not be correct - the code as it is without this change is
>> safe even when the vCPU gets onlined back later by an external
>> entity (e.g. the Xen tool stack), and it would in that case resume
>> at the return point of the VCPUOP_down hypercall. That might
>> be a heritage from the original XenoLinux tree though, and be
>> meaningless in pv-ops context - Jeremy, Konrad?
>> 
>> Possibly it was bogus/unused even in that original tree - Keir?
>>
> 
> 
> Thanks for your comments Jan!
> 
> In case this change is wrong, the other method I had in mind was to call
> cpu_bringup_and_idle() in xen_play_dead(). (Even ARM does something similar,
> in the sense that it runs the cpu bringup code including cpu_idle(), in the
> cpu offline path, namely the cpu_die() function). Would that approach work
> for xen as well? If yes, then we wouldn't have any issues to convert xen to
> generic code.

No, that wouldn't work either afaict - the function is expected
to return.

Jan

