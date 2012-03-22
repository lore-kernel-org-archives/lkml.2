Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030813Ab2CVIcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 04:32:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6963 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932078Ab2CVIcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 04:32:10 -0400
X-IronPort-AV: E=Sophos;i="4.73,629,1325433600"; 
   d="scan'208";a="4598329"
Message-ID: <4F6AE403.8070500@cn.fujitsu.com>
Date: Thu, 22 Mar 2012 16:34:11 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: Avi Kivity <avi@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Northup <digitaleric@google.com>, kvm list <kvm@vger.kernel.org>,
        Amit Shah <amit.shah@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Qemu-devel] [PATCH 0/2 v3] kvm: notify host when guest panicked
References: <4F60726E.3090807@cn.fujitsu.com> <4F607325.6050607@redhat.com> <20120314104608.GU2304@redhat.com> <4F607789.4010109@redhat.com> <4F607CE4.2060809@cn.fujitsu.com> <4F609822.7050502@redhat.com> <20120314131415.GB2304@redhat.com> <4F609A15.5020902@redhat.com> <20120314132552.GC2304@redhat.com> <CAG7+5M0gEpoJ_jnC8_4Ae-xe2rr7+CJLZh3JjAhh=p=-2bEAcA@mail.gmail.com> <20120315103923.GL2304@redhat.com> <4F61D1AF.4040603@siemens.com> <4F61D688.5040406@redhat.com> <4F6A2832.9080306@codemonkey.ws>
In-Reply-To: <4F6A2832.9080306@codemonkey.ws>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-22 16:29:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-22 16:29:58,
	Serialize complete at 2012-03-22 16:29:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 03/22/2012 03:12 AM, Anthony Liguori Wrote:
> On 03/15/2012 06:46 AM, Avi Kivity wrote:
>> On 03/15/2012 01:25 PM, Jan Kiszka wrote:
>>>>>
>>>> There was such vm exit (KVM_EXIT_HYPERCALL), but it was deemed to be a
>>>> bad idea.
>>>
>>> BTW, this would help a lot in emulating hypercalls of other hypervisors
>>> (or of KVM's VAPIC in the absence of in-kernel irqchip - I had to jump
>>> through hoops therefore) in user space. Not all those hypercall handlers
>>> actually have to reside in the KVM module.
>>>
>>
>> That is true.  On the other hand the hypercall ABI might go to pieces if
>> there was no central implementation.
> 
> Just declare that outl 0x505 is a megaultracall and s/vmcall/outb/g and
> call it a day.

Why use 0x505? Is it a reserved port, and it will not be used by any device?

How can I get all reserved port?

Thanks
Wen Congyang

> 
> The performance difference between vmcall and outl is so tiny compared
> to the cost of dropping to userspace that it really doesn't matter which
> instruction is used.
> 
> Regards,
> 
> Anthony Liguori
> 
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

