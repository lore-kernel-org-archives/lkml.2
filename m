Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0CQSfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:35:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40546 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab0CQSfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:35:06 -0400
Message-ID: <4BA11FD2.2090104@zytor.com>
Date: Wed, 17 Mar 2010 11:30:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ulrich Drepper <drepper@redhat.com>, munroesj@us.ibm.com,
       David Miller <davem@davemloft.net>, ralf@linux-mips.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@teksavvy.com, torvalds@linux-foundation.org
Subject: Re: 64-syscall args on 32-bit vs syscall()
References: <20100315134449.GB1653@linux-mips.org>	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>	 <20100315.120004.209998642.davem@davemloft.net>	 <4B9E8D67.8040209@zytor.com>  <1268685311.2335.38.camel@pasglop>	 <1268776570.19726.98.camel@spokane1.rchland.ibm.com>	 <1268785874.2335.137.camel@pasglop>  <4BA06E1B.2040706@redhat.com> <1268816179.2335.187.camel@pasglop>
In-Reply-To: <1268816179.2335.187.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 01:56 AM, Benjamin Herrenschmidt wrote:
>
> Ok, so I -may- be missing something, but I believe this won't break
> anything:
>
>   - You keep the existing syscall() exported by glibc for binary
> compatibility
>
>   - You add a new __syscall() (or whatever you want to name it) that adds
> a dummy argument at the beginning, and whose implementation shifts
> everything by 2 instead of 1 argument before calling into the kernel
>
>   - You define in unistd.h or whatever is relevant, a macro that does:
>
> #define syscall(__sysno, __args..) __syscall(0, _sysno, __args)
>

Again, this is *exactly* symbol versioning done by hand... we have 
proper symbol versioning, let's use it.

	-hpa
