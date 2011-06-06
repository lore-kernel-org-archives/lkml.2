Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1FFK5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 06:57:16 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:39714 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513Ab1FFK5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 06:57:13 -0400
Message-ID: <4DECB261.5090109@linux.vnet.ibm.com>
Date: Mon, 06 Jun 2011 12:56:33 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Jeff Dike <jdike@addtoit.com>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@Sun.COM>,
        Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>,
        Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Disable CONFIG_CONSTRUCTORS when not needed by CONFIG_GCOV_KERNEL
References: <20110605082100.GA18151@leaf>
In-Reply-To: <20110605082100.GA18151@leaf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2011 10:21, Josh Triplett wrote:
> CONFIG_CONSTRUCTORS controls support for running constructor functions
> at kernel init time.  According to commit
> b99b87f70c7785ab1e253c6220f4b0b57ce3a7f7, gcov (CONFIG_GCOV_KERNEL)
> needs this.  However, CONFIG_CONSTRUCTORS currently defaults to y, with
> no option to disable it, and CONFIG_GCOV_KERNEL depends on it.  Instead,
> default it to n and have CONFIG_GCOV_KERNEL select it, so that the
> normal case of CONFIG_GCOV_KERNEL=n will result in
> CONFIG_CONSTRUCTORS=n.
>
> Observed in the short list of =y values in a minimal kernel
> configuration.
>
> Signed-off-by: Josh Triplett<josh@joshtriplett.org>
> ---

I tested this patch and GCOV profiling still works with it applied. To 
my knowledge, GCOV profiling is the only kernel mechanism using GCC's 
constructors and this may save some bytes.

Acked-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>


Regards,
   Peter

