Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2BJRS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:18:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:61054 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab2BJRS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:18:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="65374516"
Message-ID: <4F35517F.9070904@linux.intel.com>
Date: Fri, 10 Feb 2012 09:18:55 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Do the x86 kernel entry points need an xabort on TSX cpus?
References: <CALCETrVWBdp2yyuZ54osq_QQ0a8NKUfOk8stxtuiFWq76FO7JQ@mail.gmail.com>
In-Reply-To: <CALCETrVWBdp2yyuZ54osq_QQ0a8NKUfOk8stxtuiFWq76FO7JQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 11:40 PM, Andy Lutomirski wrote:
> [...]
>
>   - Ring transitions: SYSENTER, SYSCALL, SYSEXIT, and SYSRET.
>
> I suspect that many bits of the kernel expect that things they do
> won't unhappen.  For example, it could be fun to do:
>

That's why entering the kernel will cause an abort.  In other words, you 
will ALWAYS abort when you do a read(), and you will never reach your 
_xabort().

> int devrandom = open("/dev/random", O_RDONLY);
> unsigned int abort_code = _xbegin();
>
> if (abort_code&  1) {
>    printf("Your next random byte is %d\n", (int)(abort_code>>  24));
> } else if (abort_code != 0) {
>    printf("Attack failed\n");
> } else {
>    char r;
>    read(devrandom,&r, 1);
>    _xabort(r);
> }

	-hpa

