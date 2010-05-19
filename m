Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab0ESSTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:19:14 -0400
Received: from claw.goop.org ([74.207.240.146]:50050 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab0ESSTM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:19:12 -0400
Message-ID: <4BF42B9F.3080201@goop.org>
Date: Wed, 19 May 2010 11:19:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>, Sheng Yang <sheng@linux.intel.com>
Subject: Re: [PATCH 03/12] evtchn delivery on HVM
References: <alpine.DEB.2.00.1005181054260.11380@kaball-desktop> <1274178187-20602-3-git-send-email-stefano.stabellini@eu.citrix.com> <4BF2CBA5.3020205@goop.org> <alpine.DEB.2.00.1005191315160.11380@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1005191315160.11380@kaball-desktop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 05:24 AM, Stefano Stabellini wrote:
> On Tue, 18 May 2010, Jeremy Fitzhardinge wrote:
>   
>> On 05/18/2010 03:22 AM, Stefano Stabellini wrote:
>>     
>>> From: Sheng Yang <sheng@linux.intel.com>
>>>
>>> Set the callback to receive evtchns from Xen, using the
>>> callback vector delivery mechanism.
>>>   
>>>       
>> Could you expand on this a little?  Like, why is this desireable?  What
>> functional difference does it make?  Is this patch useful in its own
>> right, or is it just laying the groundwork for something else?
>>
>>     
> In order to use PV frontends on HVM we need to receive notifications on
> event channel deliveries somehow.
>   
(OK, but I just meant update the commit comment on the patch itself.)

> Using the callback vector is the preferred way, because it is available
> independently from any (emulated) PCI device, all the vcpus can receive
> these callbacks and theoretically there is no need to interact with the
> emulated lapic (even though at the moment we are doing it anyway because
> we are using the IPI vector).
>   
> The other way is to receive interrupts from the xen platform pci device,
> but in that case interaction with the emulated lapic is unavoidable and
> we are limited to receive interrupts on vcpu 0.
>   

Perhaps you should mention this first, since it is the historical way of
doing it, and then talk about its limitations, and then talk about the
replacement to address those limitations.

    J

