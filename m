Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab1ETO2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:28:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33865 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab1ETO2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Mjkx9zLha4F7T2MFYrkJcyr/S6k76qwJp4CH64Lyjt/MQQJ8Tx1VCdEpvDm6UTb5P5
         gnASFtLFHYgGveqLGwdoNxADyTGkjcMcBZU7Z+3v0HKEY1SqxHQMfUMX8YBAq368olX1
         3CWFFEJFmaET4lWZmStYdZ1TIkZiQg4ZDA6ZI=
Message-ID: <4DD67A90.7010908@twiddle.net>
Date: Fri, 20 May 2011 07:28:32 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
        Helge Deller <deller@gmx.de>,
        "JamesE.J.Bottomley" <jejb@parisc-linux.org>
Subject: Re: [RFC][PATCH] extable: Make sure all archs define _sdata
References: <1305855298.1465.19.camel@gandalf.stny.rr.com>
In-Reply-To: <1305855298.1465.19.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2011 06:34 PM, Steven Rostedt wrote:
> Can I get an Acked-by (or comment) from the following Maintainers:
> 
>   alpha
>   m32r
>   m68k
>   mips
>   parisc
> 
> Ingo has discovered that one of my patches broke the builds of these
> architectures. Although he added a quick fix, this patch supplies the
> proper fix and touches the affected architectures. Please review and Ack
> (or NACK with guidance) this patch.
> 
> -- Steve
> 
> A new utility function is used to determine if a passed in address is
> part of core kernel data or not. It may or may not return true for RO
> data, but this utility must work for RW data. Thus both _sdata and
> _edata must be defined and continuous, without .init sections that may
> later be freed and replaced by volatile memory (memory that can be
> freed).
> 
> This utility function is used to determine if data is safe from ever
> being freed. Thus it should return true for all RW global data that is
> not in a module or has been allocated, or false otherwise.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Richard Henderson <rth@twiddle.net>

Although I suppose if we're supposedly standardizing on _sdata,
the two uses of _data in arch/alpha/mm/ could be transitioned.


r~
