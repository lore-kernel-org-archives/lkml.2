Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0EJRbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:31:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56821 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0EJRbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:31:11 -0400
Message-ID: <4BE842C3.5040300@zytor.com>
Date: Mon, 10 May 2010 10:30:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "hjanssen@microsoft.com" <hjanssen@microsoft.com>,
       "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/cpu] Modify the VMware balloon driver for the new x86_hyper
 API
References: <4BE49778.6060800@zytor.com> <201005100106.07156.dtor@vmware.com> <4BE824F0.3030301@zytor.com> <201005100917.28980.dtor@vmware.com>
In-Reply-To: <201005100917.28980.dtor@vmware.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2010 09:17 AM, Dmitry Torokhov wrote:
> On Monday 10 May 2010 08:23:28 am H. Peter Anvin wrote:
>> On 05/10/2010 01:06 AM, Dmitry Torokhov wrote:
>>> Source please? I was not aware that there was a standard governing
>>> returns code for module init methods.
>>
>> ENODEV means "not a device node."
>> ENXIO means "hardware not present."
>>
> 
> There is no device node in question. Again, could you please point me to
> the list of allowed error codes for init methods? According to SUS,
> we need to follow ERROR section of the appropriate function, and I do
> not believe that spec covers cases if driver binding and module loading. 
> 
> FWIW -ENODEV is explicitly allowed in our device core and means "device
> not found", especially in context of platform devices. I do not see the
> need of changing that.
> 

The problem with this abuse of ENODEV is that people start using it
elsewhere, where it *DOES* matter than ENXIO is the proper return code.
 Yes, we handle incorrect uses of ENODEV, but the right thing to do is
to teach people to use ENXIO properly.

	-hpa

