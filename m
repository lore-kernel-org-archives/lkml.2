Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0KZQ75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 11:59:57 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61338 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627Ab0KZQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 11:59:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xxOhejYymoVorHDXn/gghLVYWXMGMiEoSYO+PBp3xFNhRSLkcAX4rB3diImQR0nxWP
         jqa9olQLQvMniOAulu+RVuX9cvmhdremyujYyWy74eFhccbqRthAIBS63JYEdqvzqIqf
         80dfwiX4Vo1Xvw5a/kaO5Zk+4xvn1EpFlCWuo=
Subject: Re: [PATCH] printk: use this_cpu_{read|write} api on printk_pending
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <alpine.DEB.2.00.1011261038360.13524@router.home>
References: <20101126120235.406766476@de.ibm.com>
	 <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>
	 <1290788536.2855.237.camel@edumazet-laptop>
	 <alpine.DEB.2.00.1011261038360.13524@router.home>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 17:59:51 +0100
Message-ID: <1290790791.2855.259.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 26 novembre 2010 à 10:40 -0600, Christoph Lameter a écrit :

> This only works if printk_needs_cpu is always passed the current cpu. The
> check for cpu_is_offline suggests that the function is also used for other
> cpus. The __this_cpu_read() will then get the printk_pending stat for the
> current cpu and not for the specified cpu.
> 
> 

I guess you read the changelog too fast ;)

I posted this patch after noticing printk_needs_cpu() was always used
for the current cpu.

We have other functions around, that always work for the current cpu.

We pass cpu as a parameter, mostly because smp_processor_id() was a bit
expensive in old kernels, and is still expensive because of sanity
tests.

Now we have this_cpu_ api, we probably can do a cleanup to avoid now
useless parameter passing.

If we had this_cpu_is_online() function, we could avoid (int cpu) param
in printk_needs_cpu()



