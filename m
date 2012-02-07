Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab2BGNSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:18:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642Ab2BGNS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:18:29 -0500
Message-ID: <4F31249D.1040700@redhat.com>
Date: Tue, 07 Feb 2012 15:18:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Scott Wood <scottwood@freescale.com>,
        Eric Northup <digitaleric@google.com>,
        qemu-devel <qemu-devel@nongnu.org>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>	<4F2C6517.3040203@codemonkey.ws>	<4F302E0D.20302@freescale.com> <4F3118EA.7040302@codemonkey.ws> <4F311BBD.5050600@redhat.com> <4F311E64.10604@codemonkey.ws>
In-Reply-To: <4F311E64.10604@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2012 02:51 PM, Anthony Liguori wrote:
> On 02/07/2012 06:40 AM, Avi Kivity wrote:
>> On 02/07/2012 02:28 PM, Anthony Liguori wrote:
>>>
>>>> It's a potential source of exploits
>>>> (from bugs in KVM or in hardware). I can see people wanting to be
>>>> selective with access because of that.
>>>
>>> As is true of the rest of the kernel.
>>>
>>> If you want finer grain access control, that's exactly why we have 
>>> things like
>>> LSM and SELinux. You can add the appropriate LSM hooks into the KVM
>>> infrastructure and setup default SELinux policies appropriately.
>>
>> LSMs protect objects, not syscalls. There isn't an object to protect 
>> here
>> (except the fake /dev/kvm object).
>
> A VM can be an object.
>

Not really, it's not accessible in a namespace.  How would you label it?

Maybe we can reuse the process label/context (not sure what the right 
term is for a process).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

