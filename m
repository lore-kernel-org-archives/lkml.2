Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2HGW1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:27:04 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:52651 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755746Ab2HGW1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:27:01 -0400
Message-ID: <50219628.1080909@linaro.org>
Date: Tue, 07 Aug 2012 15:26:48 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: lkml <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
References: <50215A7E.8000701@linaro.org> <CAHC9VhTSS8+-OcX9uK0xqnYC3-y0axVGs1m+kuC6+M6HvmSmgg@mail.gmail.com> <50218F7E.1060004@linaro.org> <CAHC9VhTd-d9NgWoU6_o9qw0bq4ZbuTEj8E_jRYyDXPWQaLLdog@mail.gmail.com>
In-Reply-To: <CAHC9VhTd-d9NgWoU6_o9qw0bq4ZbuTEj8E_jRYyDXPWQaLLdog@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080722-7182-0000-0000-00000235EC71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 03:01 PM, Paul Moore wrote:
> On Tue, Aug 7, 2012 at 5:58 PM, John Stultz <john.stultz@linaro.org> wrote:
>> On 08/07/2012 02:50 PM, Paul Moore wrote:
>>> On Tue, Aug 7, 2012 at 2:12 PM, John Stultz <john.stultz@linaro.org>
>>> wrote:
>>>> Hi,
>>>>       With my kvm environment using 3.6-rc1+, I'm seeing NULL pointer
>>>> dereferences in selinux_ip_postroute_compat(). It looks like the sksec
>>>> value
>>>> is null and we die in the following line:
>>>>
>>>>       if (selinux_xfrm_postroute_last(sksec->sid, skb, &ad, proto))
>>>>
>>>> This triggers every time I shutdown the machine, but has also triggered
>>>> randomly after a few hours.
>>>>
>>>> This is on an ubuntu 12.04 image, not using selinux.
>>> NOTE: Adding the SELinux list to the CC line
>> Thanks!
>>
>>> Hi,
>>>
>>> I'm trying to understand this and I was hoping you could you clarify a
>>> few things for me:
>>>
>>> * Is the panic in the Ubuntu 12.04 guest, or the host?  If the host,
>>> could you share what distribution you are using?
>> Sorry, its a 12.04 guest.  I think the host is Ubuntu 12.04 as well.
>>
>>
>>> * When you say you are not using SELinux, could you be more specific?
>>> It seems odd that you are not using SELinux but the panic is happening
>>> in a SELinux hook.
>> I just mean that, being Ubuntu,  the system (userland) isn't configured to
>> use selinux.  SELinux is just enabled in the kernel config.
> Thanks for the quick response, I'll setup an Ubuntu guest and see if I
> can reproduce this ... something is odd.  Anything non-standard about
> your guest install or anything else you think might be helpful?
Don't think so.  Just a standard 64bit ubuntu 12.04 install.

Since I'm booting kernel/initrd from the commandline, the initrd *may* 
be older then 12.04, I can't quite remember when I copied that out of 
the image. I'll see if it still triggers if I copy the current initrd out.

thanks
-john

