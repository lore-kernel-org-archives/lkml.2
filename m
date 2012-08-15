Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab2HOLAZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 07:00:25 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:51628 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2HOLAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 07:00:23 -0400
Message-ID: <20120815140016.76673zs818g2hagw@www.81.fi>
Date: Wed, 15 Aug 2012 14:00:16 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Borislav Petkov <bp@alien8.de>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?b?TfxsbGVy?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
References: <20120527144919.GE17705@kronos.redsun>
 <20120815114216.209814z4mq3hxqe8@www.81.fi>
 <20120815092804.GA14676@x1.osrc.amd.com>
In-Reply-To: <20120815092804.GA14676@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.7)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Borislav Petkov <bp@alien8.de>:

> On Wed, Aug 15, 2012 at 11:42:16AM +0300, Jussi Kivilinna wrote:
>> I started thinking about the performance on AMD Bulldozer.
>> vmovq/vmovd/vpextr*/vpinsr* between FPU and general purpose registers
>> on AMD CPU is alot slower (latencies from 8 to 12 cycles) than on
>> Intel sandy-bridge (where instructions have latency of 1 to 2). See:
>> http://www.agner.org/optimize/instruction_tables.pdf
>>
>> It would be really good, if implementation could be tested on AMD CPU
>> to determinate, if it causes performance regression. However I don't
>> have access to machine with such CPU.
>
> But I do. :)
>
> And if you tell me exactly how to run the tests and on what kernel, I'll
> try to do so.
>

Twofish-avx (CONFIG_TWOFISH_AVX_X86_64) is available in 3.6-rc1. For  
testing you need CRYPTO_TEST build as module. You should turn off  
turbo-core, freq-scaling, etc.

Testing twofish-avx ('async twofish' speed test):
  modprobe twofish-avx-x86_64
  modprobe tcrypt mode=504 sec=1

Testing twofish-x86_64-3way ('sync twofish' speed test):
  modprobe twofish-x86_64-3way
  modprobe tcrypt mode=202 sec=1

Loading tcrypt will block until tests are complete, after which  
modprobe will return with error. This is expected. Results are in  
kernel log.

-Jussi

> HTH.
>
> --
> Regards/Gruss,
> Boris.
>
>



