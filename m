Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab1KQHTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 02:19:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab1KQHTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 02:19:45 -0500
Message-ID: <4EC4B60C.3030706@redhat.com>
Date: Thu, 17 Nov 2011 15:21:48 +0800
From: Dave Young <dyoung@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Hartrick <tim@edgecast.com>
CC: WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: Crash during vmcore_init
References: <1318376345.2050.20.camel@boudreau>	<j9r5m5$b18$1@dough.gmane.org>	<1321296650.2066.17.camel@boudreau>	<4EC21F67.10905@redhat.com>	<1321396371.4198.5.camel@boudreau>	<4EC31E55.6040809@redhat.com>	<1321467647.2137.4.camel@boudreau>	<4EC47FCA.5090908@redhat.com>	<CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com>	<4EC491B3.705@redhat.com> <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com>
In-Reply-To: <CAMMEr5k_ynqg5-7Looar2DxXTGZcMqi5Lo+jtETn9awO_bsaGg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 01:22 PM, Tim Hartrick wrote:

> Tejun, Dave,
> 
> I will be happy to answer any questions about our environment or test
> debug or other patches.  Just tell me what you need.


Thank you. Can you share your kernel config?

> 
> tim
> 
> On Nov 16, 2011 8:44 PM, "Dave Young" <dyoung@redhat.com
> <mailto:dyoung@redhat.com>> wrote:
> 
>     On 11/17/2011 12:34 PM, Tejun Heo wrote:
> 
>     > Hello,
>     >
>     > On Wed, Nov 16, 2011 at 7:30 PM, Dave Young <dyoung@redhat.com
>     <mailto:dyoung@redhat.com>> wrote:
>     >> This addr is converted to an invalid phys address,
>     >
>     > I'm a bit lost on the context here. Who's calling
>     per_cpu_ptr_to_phys()?
> 
> 
>     It's drivers/base/cpu.c : show_crash_notes()
> 
>     >
>     >> looking the code below:
>     >>       if (in_first_chunk) {
>     >>                if (!is_vmalloc_addr(addr))
>     >>                        return __pa(addr);
>     >>                else
>     >>                        return page_to_phys(vmalloc_to_page(addr));
>     >>        } else
>     >>                return page_to_phys(pcpu_addr_to_page(addr));
>     >>
>     >> I dont understand per cpu allocation well, if addr is not in
>     first chunk
>     >> then it should be in vmalloc area?
>     >
>     > Yes, it is. First chunk can be embedded in the kernel linear address
>     > space but from the second one, it's always set up from the top of the
>     > vmalloc area with the same offset layout as the first chunk.
> 
> 
>     in this case ffff880667c19ad0 fall out of vmalloc area and it's not in
>     first chunk also.
> 
>     >
>     >> Tejun, do you have any idea about this?
>     >
>     > Can you please tell me how to reproduce the problem? I'll try to find
>     > out what's going on.
> 
> 
>     make sure kernel support CRASH DUMP, then cat
>     /sys/devices/system/cpu/cpu[x]/crash_notes
> 
>     Tim Hartrick <tim@edgecast.com <mailto:tim@edgecast.com>> reported
>     the problem when test kdump.
>     But I can not reproduce this. I think tim can help to test
> 
>     >
>     > Thanks.
>     >
> 
> 
> 
>     --
>     Thanks
>     Dave
> 



-- 
Thanks
Dave
