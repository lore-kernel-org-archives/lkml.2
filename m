Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab3ADOiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:38:50 -0500
Received: from smtp.citrix.com ([66.165.176.89]:37062 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738Ab3ADOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:38:48 -0500
X-IronPort-AV: E=Sophos;i="4.84,409,1355097600"; 
   d="scan'208";a="2701590"
Message-ID: <50E6E974.5090805@citrix.com>
Date: Fri, 4 Jan 2013 14:38:44 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: Andrew Cooper <andrew.cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "maxim.uvarov@oracle.com" <maxim.uvarov@oracle.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "jbeulich@suse.com" <jbeulich@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [Xen-devel] [PATCH v3 00/11] xen: Initial kexec/kdump implementation
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>	<50DBC856.6030208@zytor.com>	<791b4922-078f-4adc-b3f3-0651f2266147@email.android.com>	<50DC58C4.3000307@citrix.com> <874nj7qsor.fsf@xmission.com>	<50E41973.9050705@citrix.com> <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
In-Reply-To: <20130104142257.GC3346@host-192-168-1-59.local.net-space.pl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/13 14:22, Daniel Kiper wrote:
> On Wed, Jan 02, 2013 at 11:26:43AM +0000, Andrew Cooper wrote:
>> On 27/12/12 18:02, Eric W. Biederman wrote:
>>> Andrew Cooper<andrew.cooper3@citrix.com>  writes:
>>>
>>>> On 27/12/2012 07:53, Eric W. Biederman wrote:
>>>>> The syscall ABI still has the wrong semantics.
>>>>>
>>>>> Aka totally unmaintainable and umergeable.
>>>>>
>>>>> The concept of domU support is also strange.  What does domU support even mean, when the dom0 support is loading a kernel to pick up Xen when Xen falls over.
>>>> There are two requirements pulling at this patch series, but I agree
>>>> that we need to clarify them.
>>> It probably make sense to split them apart a little even.
>>>
>>>
>>
>> Thinking about this split, there might be a way to simply it even more.
>>
>> /sbin/kexec can load the "Xen" crash kernel itself by issuing
>> hypercalls using /dev/xen/privcmd.  This would remove the need for
>> the dom0 kernel to distinguish between loading a crash kernel for
>> itself and loading a kernel for Xen.
>>
>> Or is this just a silly idea complicating the matter?
> 
> This is impossible with current Xen kexec/kdump interface.
> It should be changed to do that. However, I suppose that
> Xen community would not be interested in such changes.

I don't see why the hypercall ABI cannot be extended with new sub-ops
that do the right thing -- the existing ABI is a bit weird.

I plan to start prototyping something shortly (hopefully next week) for
the Xen kexec case.

David
