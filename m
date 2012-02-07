Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab2BGPPT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:15:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60142 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2BGPPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:15:17 -0500
Message-ID: <4F314000.6060401@codemonkey.ws>
Date: Tue, 07 Feb 2012 09:15:12 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Scott Wood <scottwood@freescale.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>, KVM list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Chris Wright <chrisw@redhat.com>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>	<4F2C6517.3040203@codemonkey.ws>	<4F302E0D.20302@freescale.com>	<4F3118EA.7040302@codemonkey.ws> <4F311BBD.5050600@redhat.com>	<4F311E64.10604@codemonkey.ws> <4F31249D.1040700@redhat.com>
In-Reply-To: <4F31249D.1040700@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 07:18 AM, Avi Kivity wrote:
> On 02/07/2012 02:51 PM, Anthony Liguori wrote:
>> On 02/07/2012 06:40 AM, Avi Kivity wrote:
>>> On 02/07/2012 02:28 PM, Anthony Liguori wrote:
>>>>
>>>>> It's a potential source of exploits
>>>>> (from bugs in KVM or in hardware). I can see people wanting to be
>>>>> selective with access because of that.
>>>>
>>>> As is true of the rest of the kernel.
>>>>
>>>> If you want finer grain access control, that's exactly why we have things like
>>>> LSM and SELinux. You can add the appropriate LSM hooks into the KVM
>>>> infrastructure and setup default SELinux policies appropriately.
>>>
>>> LSMs protect objects, not syscalls. There isn't an object to protect here
>>> (except the fake /dev/kvm object).
>>
>> A VM can be an object.
>>
>
> Not really, it's not accessible in a namespace. How would you label it?

Labels can originate from userspace, IIUC, so I think it's possible for QEMU (or 
whatever the userspace is) to set the label for the VM while it's creating it. 
I think this is how most of the labeling for X and things of that nature works.

Maybe Chris can set me straight.

> Maybe we can reuse the process label/context (not sure what the right term is
> for a process).

Regards,

Anthony Liguori

>

