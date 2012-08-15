Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab2HOImX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:42:23 -0400
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41390 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab2HOImT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:42:19 -0400
Message-ID: <20120815114216.209814z4mq3hxqe8@www.81.fi>
Date: Wed, 15 Aug 2012 11:42:16 +0300
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Tilo =?iso-8859-1?b?TfxsbGVy?= 
	<tilo.mueller@informatik.uni-erlangen.de>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler
 implementation
References: <20120527144919.GE17705@kronos.redsun>
In-Reply-To: <20120527144919.GE17705@kronos.redsun>
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

Quoting Johannes Goetzfried  
<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>:

> This patch adds a x86_64/avx assembler implementation of the Twofish block
> cipher. The implementation processes eight blocks in parallel (two 4 block
> chunk AVX operations). The table-lookups are done in general-purpose  
> registers.
> For small blocksizes the 3way-parallel functions from the twofish-x86_64-3way
> module are called. A good performance increase is provided for blocksizes
> greater or equal to 128B.
>
> Patch has been tested with tcrypt and automated filesystem tests.
>
> Tcrypt benchmark results:
>
> Intel Core i5-2500 CPU (fam:6, model:42, step:7)

I started thinking about the performance on AMD Bulldozer.  
vmovq/vmovd/vpextr*/vpinsr* between FPU and general purpose registers  
on AMD CPU is alot slower (latencies from 8 to 12 cycles) than on  
Intel sandy-bridge (where instructions have latency of 1 to 2). See:  
http://www.agner.org/optimize/instruction_tables.pdf

It would be really good, if implementation could be tested on AMD CPU  
to determinate, if it causes performance regression. However I don't  
have access to machine with such CPU.

-Jussi

