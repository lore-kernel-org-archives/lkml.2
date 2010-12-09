Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab0LISHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 13:07:13 -0500
Received: from claw.goop.org ([74.207.240.146]:59209 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab0LISHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 13:07:12 -0500
Message-ID: <4D011ACE.2020501@goop.org>
Date: Thu, 09 Dec 2010 10:07:10 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Pasi_K=E4rkk=E4inen?= <pasik@iki.fi>
CC: Vasiliy G Tolstov <v.tolstov@selfip.ru>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Jeremy@ikiaikainen.iki.fi" <Jeremy@ikiaikainen.iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 0/2] Xen PV on HVM multiple PV consoles
References: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop> <1291236234.22027.0.camel@mobile> <alpine.DEB.2.00.1012021720170.14723@kaball-desktop> <1291404900.5298.15.camel@mobile> <alpine.DEB.2.00.1012061035070.9029@kaball-desktop> <1291640614.32324.85.camel@work.selfip.ru> <alpine.DEB.2.00.1012071026430.2390@kaball-desktop> <1291892412.30565.3.camel@vase> <20101209121259.GQ2754@reaktio.net>
In-Reply-To: <20101209121259.GQ2754@reaktio.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2010 04:12 AM, Pasi Kärkkäinen wrote:
> On Thu, Dec 09, 2010 at 02:00:12PM +0300, Vasiliy G Tolstov wrote:
>> On Tue, 2010-12-07 at 10:30 +0000, Stefano Stabellini wrote:
>>> On Mon, 6 Dec 2010, Vasiliy G Tolstov wrote:
>>>> On Mon, 2010-12-06 at 10:36 +0000, Stefano Stabellini wrote:
>>>>
>>>>> Could you please add CONFIG_DEBUG_INFO=y to your kernel config, so that
>>>>> we can see the name of the functions in the stack trace?
>>>>>
>>>> After add debug kernel not crushed. I'm test more expensive it now. Can
>>>> You provide ps auxwww | grep qemu-dm after creating domain with two
>>>> serial consoles? (sles does not have libxl, i want to write now wrapper
>>>> to qemu-dm, after that try to compile rpm from spec to support libxl).
>>>>
>>> There is no need for any special command line arguments to qemu-dm, it
>>> is going to create as many PV serials as configured on xenstored by
>>> libxl, give a look at tools/libxl/libxl.c:libxl_device_console_add.
>>> The output of the serial is the one specified on the node "output" on
>>> xenstore.
>> I reproduce kernel crush:
>>
> You need to enable debugging options in your kernel so we can see function
> names in the trace.

That's a Xen-generated dump, so that's the best you're going to get for now.

Vasiliy, you'll need to use System.map or gdb to convert the RIP to a
Linux symbol, and ideally go through the stack dump and see if you can
construct a backtrace.

(Dear lazyweb: there ought to be a program/script which can take a Xen
dump and convert the addresses to symbols like ksymoops used to do. 
Somethat that can reformat a Xen dump to a kernel oops for ksymoops
would be a good first step.)

    J

> -- Pasi
>
>> With attached config file kernel from jeremy stable-2.6.32.x boot ok and
>> noisy debug info
>> If i compile with this config from You branch stable-2.6.32-pvconsole
>> kernel crushed. Nothing displays. Only xm dmesg says:
>>
>> (XEN) d47:v0: unhandled page fault (ec=0000)
>> (XEN) Pagetable walk from 0000000000000010:
>> (XEN)  L4[0x000] = 000000083870a027 00000000000013f9
>> (XEN)  L3[0x000] = 0000000000000000 ffffffffffffffff
>> (XEN) domain_crash_sync called from entry.S
>> (XEN) Domain 47 (vcpu#0) crashed on cpu#15:
>> (XEN) ----[ Xen-4.0.0_21091_06-0.2.1  x86_64  debug=n  Not tainted ]----
>> (XEN) CPU:    15
>> (XEN) RIP:    e019:[<00000000c10aaa3f>]
>> (XEN) RFLAGS: 0000000000000246   EM: 1   CONTEXT: pv guest
>> (XEN) rax: 0000000000000000   rbx: 00000000c146f5a0   rcx:
>> 00000000c1445298
>> (XEN) rdx: 0000000000000000   rsi: 0000000000008000   rdi:
>> 0000000000000000
>> (XEN) rbp: 00000000c13f7e60   rsp: 00000000c13f7e34   r8:
>> 0000000000000000
>> (XEN) r9:  0000000000000000   r10: 0000000000000000   r11:
>> 0000000000000000
>> (XEN) r12: 0000000000000000   r13: 0000000000000000   r14:
>> 0000000000000000
>> (XEN) r15: 0000000000000000   cr0: 000000008005003b   cr4:
>> 00000000000026f0
>> (XEN) cr3: 000000083fe24000   cr2: 0000000000000010
>> (XEN) ds: e021   es: e021   fs: 00d8   gs: 0000   ss: e021   cs: e019
>> (XEN) Guest stack trace from esp=c13f7e34:
>> (XEN)   00000000 c10aaa3f 0001e019 00010046 c10392d6 c1445298 c11d0e17
>> 00000004
>> (XEN)   c146f5a0 00000000 c14b0cd9 c13f7e70 c11d0e17 c146f5a0 00000000
>> c13f7e78
>> (XEN)   c11d0ed4 c13f7e98 c103936f c14b0cc8 004b0cc0 00000000 c14b0cd9
>> 00000000
>> (XEN)   c14b0cd9 c13f7ea8 c1495868 c14d215c c14b0ccd c13f7ebc c148541b
>> c14b0ccd
>> (XEN)   fffffffe 00000000 c13f7ef8 c1048703 c13f7ef8 00000000 c137df19
>> 00000000
>> (XEN)   0000000f 00000000 00000000 00000000 c14b0cd9 c14b0cdd 00000000
>> c1480f40
>> (XEN)   c1481900 c13f7f08 c14851fd 00000000 c14853d2 c13f7f10 c14853c6
>> c13f7f94
>> (XEN)   c148a282 c13f7f20 c13f7fa4 00000000 c104e01e 00000005 00000000
>> 00000000
>> (XEN)   00000000 00000000 00000098 205b7f4c 30202020 3030302e 5d303030
>> c1050020
>> (XEN)   c13f7f78 c1bb60d0 c13f7f68 00000024 00000000 c1bb60c0 c1bb5884
>> c1394221
>> (XEN)   00000000 c13f7fdc 00000000 c13f7f94 c10392f6 00000000 c13f7fdc
>> 00000000
>> (XEN)   c13f7fac c148562f c137e0bc c12b2020 c14b2c60 00000000 c13f7fb8
>> c14850a2
>> (XEN)   c21f8000 c13f7ffc c1487d4a 00000000 00000000 00000000 00000000
>> 00000000
>> (XEN)   00000000 00000000 1f898975 80980201 10100800 000106a5 00000000
>> 00000000
>> (XEN)   c21f8000 00000000 00000000
>> (XEN) cpupool_rm_domain(dom=47,pool=0) n_dom 1
>> (XEN) mm.c:2562:d0 Unknown domain '47'
>> (XEN) mm.c:2562:d0 Unknown domain '47'
>> (XEN) mm.c:2562:d0 Unknown domain '47'
>> (XEN) mm.c:2562:d0 Unknown domain '47'
>>
>>
>>
>> -- 
>> Vasiliy G Tolstov <v.tolstov@selfip.ru>
>> Selfip.Ru
>>
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xensource.com
>> http://lists.xensource.com/xen-devel

