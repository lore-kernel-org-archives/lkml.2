Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2HGV6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 17:58:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35298 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab2HGV6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 17:58:44 -0400
Message-ID: <50218F7E.1060004@linaro.org>
Date: Tue, 07 Aug 2012 14:58:22 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: lkml <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        James Morris <james.l.morris@oracle.com>, selinux@tycho.nsa.gov
Subject: Re: NULL pointer dereference in selinux_ip_postroute_compat
References: <50215A7E.8000701@linaro.org> <CAHC9VhTSS8+-OcX9uK0xqnYC3-y0axVGs1m+kuC6+M6HvmSmgg@mail.gmail.com>
In-Reply-To: <CAHC9VhTSS8+-OcX9uK0xqnYC3-y0axVGs1m+kuC6+M6HvmSmgg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080721-7282-0000-0000-00000BBE4C0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 02:50 PM, Paul Moore wrote:
> On Tue, Aug 7, 2012 at 2:12 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Hi,
>>      With my kvm environment using 3.6-rc1+, I'm seeing NULL pointer
>> dereferences in selinux_ip_postroute_compat(). It looks like the sksec value
>> is null and we die in the following line:
>>
>>      if (selinux_xfrm_postroute_last(sksec->sid, skb, &ad, proto))
>>
>> This triggers every time I shutdown the machine, but has also triggered
>> randomly after a few hours.
>>
>> This is on an ubuntu 12.04 image, not using selinux.
> NOTE: Adding the SELinux list to the CC line
Thanks!

>
> Hi,
>
> I'm trying to understand this and I was hoping you could you clarify a
> few things for me:
>
> * Is the panic in the Ubuntu 12.04 guest, or the host?  If the host,
> could you share what distribution you are using?
Sorry, its a 12.04 guest.  I think the host is Ubuntu 12.04 as well.

> * When you say you are not using SELinux, could you be more specific?
> It seems odd that you are not using SELinux but the panic is happening
> in a SELinux hook.
I just mean that, being Ubuntu,  the system (userland) isn't configured 
to use selinux.  SELinux is just enabled in the kernel config.

thanks
-john

