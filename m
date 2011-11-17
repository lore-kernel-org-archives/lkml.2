Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1KQEej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 23:34:39 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39771 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1KQEei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 23:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <4EC47FCA.5090908@redhat.com>
References: <1318376345.2050.20.camel@boudreau>
	<j9r5m5$b18$1@dough.gmane.org>
	<1321296650.2066.17.camel@boudreau>
	<4EC21F67.10905@redhat.com>
	<1321396371.4198.5.camel@boudreau>
	<4EC31E55.6040809@redhat.com>
	<1321467647.2137.4.camel@boudreau>
	<4EC47FCA.5090908@redhat.com>
Date: Wed, 16 Nov 2011 20:34:36 -0800
X-Google-Sender-Auth: XKR3gHtxzNQJTLCetmtAsTT1ccM
Message-ID: <CAOS58YMOuJrvGxE1VxsU=ZPTLgY60HDJoLFjTowx9ZApUQ3tTw@mail.gmail.com>
Subject: Re: Crash during vmcore_init
From: Tejun Heo <tj@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: tim@edgecast.com, WANG Cong <xiyou.wangcong@gmail.com>,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 16, 2011 at 7:30 PM, Dave Young <dyoung@redhat.com> wrote:
> This addr is converted to an invalid phys address,

I'm a bit lost on the context here. Who's calling per_cpu_ptr_to_phys()?

> looking the code below:
>       if (in_first_chunk) {
>                if (!is_vmalloc_addr(addr))
>                        return __pa(addr);
>                else
>                        return page_to_phys(vmalloc_to_page(addr));
>        } else
>                return page_to_phys(pcpu_addr_to_page(addr));
>
> I dont understand per cpu allocation well, if addr is not in first chunk
> then it should be in vmalloc area?

Yes, it is. First chunk can be embedded in the kernel linear address
space but from the second one, it's always set up from the top of the
vmalloc area with the same offset layout as the first chunk.

> Tejun, do you have any idea about this?

Can you please tell me how to reproduce the problem? I'll try to find
out what's going on.

Thanks.

-- 
tejun
