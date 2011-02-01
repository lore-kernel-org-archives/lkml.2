Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab1BAWQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 17:16:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40299 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab1BAWQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 17:16:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UF6t+qRZBrtwxhAaFhMlaMeZa8zKgfkk565G/L5fAoASWPoZgNRrJBro2I+enTYyGx
         Xe84hqqE/j8nuG7D8uFmcWYHX4mGnwFSpLCK4Qbauel0N+t/aZMTMvWPu+KzUikIhXaD
         W+lhzCD7HxgYArI7tPNIuVOrT/0BLLz90CTsY=
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
References: <alpine.SOC.1.00.1102012342200.25944@math.ut.ee>
Date: Tue, 1 Feb 2011 17:16:40 -0500
X-Google-Sender-Auth: B_Vkkfqd_nxiVj1QrMS7QXbYsNs
Message-ID: <AANLkTimay4R5Jd9cPyiwy6WizQwcJpC-HR9LmrdZ=bZe@mail.gmail.com>
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
From: "Carlos O'Donell" <carlos@systemhalted.org>
To: Meelis Roos <mroos@linux.ee>
Cc: linux-parisc@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 1, 2011 at 5:00 PM, Meelis Roos <mroos@linux.ee> wrote:
> I have been testing devel kernels on SMP L1000 successfully until
> 2.6.38-rc2-00324-g70d1f36 included. The testing means booting the new
> kernel and running aptitude to update to current debian unstable.
>
> Now I tried 2.6.38-rc3 and got a crash from aptitude on 2 out of 2
> tries. Maybe aptitude was broken inbetween but it looks like a kernel
> bug. Retried 2.6.38-rc2-00324-g70d1f36 and that seemed to work fine so
> it's more likely a kernel problem.
>
> What additional information can I provide?
>
> [   74.590000]
> [   74.590000] do_page_fault() pid=979 command='aptitude' type=15 address=0x0000002d
> [   74.590000]
> [   74.590000]      YZrvWESTHLNXBCVMcbcbcbcbOGFRQPDI
> [   74.590000] PSW: 00000000000001001111111100001111 Not tainted
> [   74.590000] r00-03  000000ff0004ff0f 000000004027b5ac 00000000405df23b 000000004067e884
> [   74.590000] r04-07  000000004067c860 000000004067e6d0 000000004067e880 00000000c014b7d0
> [   74.590000] r08-11  0000000000000001 0000000000000001 000000004067c860 0000000041b082c8
> [   74.590000] r12-15  000000004067e730 000000004067e6d0 000000004067c860 000000004067c860
> [   74.590000] r16-19  000000004067c860 000000004067e060 0000000000000000 000000004067c860
> [   74.590000] r20-23  0000000000000229 0000000000000000 0000000000000000 0000000000000000
> [   74.590000] r24-27  fffffffffffffff5 ffffffffffffffd3 000000004067e730 00000000004227a4
> [   74.590000] r28-31  000000000000002d 0000000000000000 00000000c014b8c0 00000000402688db
> [   74.590000] sr00-03  0000000000228800 0000000000228800 0000000000000000 0000000000228800
> [   74.590000] sr04-07  0000000000228800 0000000000228800 0000000000228800 0000000000228800
> [   74.590000]
> [   74.590000]       VZOUICununcqcqcqcqcqcrmunTDVZOUI
> [   74.590000] FPSR: 00001000001000100010000000000000
> [   74.590000] FPER1: 00000000
> [   74.590000] fr00-03  0822200000000000 0000000000000000 0000000000000000 0000000000000000
> [   74.590000] fr04-07  0000000a00000000 0000000000000000 0000000000000000 0000000000000000
> [   74.590000] fr08-11  0000000000000000 00000000406cf120 00000000401563e8 00000000404c59d8
> [   74.590000] fr12-15  000000000804000f 000000000800000f 00000000401563e8 00000000ffc60460
> [   74.590000] fr16-19  00000000406cf120 0000000040639d54 0000000000000046 0000000040599294
> [   74.590000] fr20-23  00000000ffc60348 00000000406dd920 0000000000000038 4038000000000000
> [   74.590000] fr24-27  0000000000000000 0000000000000000 3ff0000000000000 412e848c00000000
> [   74.590000] fr28-31  0000000040599250 00000000ffc60357 00000000ffc60357 00000000405dfba8
> [   74.590000]
> [   74.590000] IASQ: 0000000000228800 0000000000228800 IAOQ: 00000000405df25b 00000000405df25f
> [   74.590000]  IIR: 0f80108b    ISR: 0000000000228800  IOR: 000000000000002d
> [   74.590000]  CPU:        0   CR30: 00000000fe050000 CR31: 0000000000008020
> [   74.590000]  ORIG_R28: 0000000000000080
> [   74.590000]  IAOQ[0]: 00000000405df25b
> [   74.590000]  IAOQ[1]: 00000000405df25f
> [   74.590000]  RP(r2): 00000000405df23b

The rp (return pointer) is pointing back into what appears to be a
shared library (always loaded around 0x4???????).

The iir (interrupting instruction register) is instruction "0:   0f 80
10 8b     ldw 0(ret0),r11" (you can do this yourself with "disasm"
from http://cvs.parisc-linux.org/build-tools/disasm?revision=1.1&view=markup).

You can see that ret0 is indeed 0x2d (the address of the fault), and
loading 0x0 + 0x2d will cause a fault and kill your program.

However, the failure probably happened earlier.

As James says, you should try to bisect exactly which commit caused the failure.

Cheers,
CArlos.
