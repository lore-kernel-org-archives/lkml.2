Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0JAGYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 02:24:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab0JAGYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 02:24:37 -0400
Message-ID: <4CA57F93.8010101@redhat.com>
Date: Fri, 01 Oct 2010 14:28:35 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Fix wrong source path in scripts/namespace.pl
References: <1285828138-5873-1-git-send-email-amwang@redhat.com> <20101001145618.613e3e1f@s6510>
In-Reply-To: <20101001145618.613e3e1f@s6510>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/10 13:56, Stephen Hemminger wrote:
> On Thu, 30 Sep 2010 14:28:55 +0800
> Amerigo Wang<amwang@redhat.com>  wrote:
>
>> File::Find will do chdir automatically, so we need to get
>> the absolute patch with $File::Find::dir.
>>
>> Reported-by: Stephen Hemminger<shemminger@vyatta.com>
>> Signed-off-by: Amerigo Wang<amwang@redhat.com>
>> ---
>>   scripts/namespace.pl |    8 ++++----
>>   1 files changed, 4 insertions(+), 4 deletions(-)
>
> How did you test this? I tried your patches and when I run
> it on a compiled kernel in a way that most developers would
> do it:
>   $ make allmodconfig
>   $ make
>   $ ./scripts/namespace.pl


I use 'make namespacecheck'.

>
> With your patch it still doesn't find the kernel source files.
> I find it frustrating because my patch worked, yours didn't.
>
> --------
> No source file found for arch/x86/crypto/aes-i586-asm_32.o
> No source file found for arch/x86/crypto/aes_glue.o
...

Actually, this shows it is working. :)

There are two reasons why you got so many of these:

1) You didn't do a 'make mrproper', so some source file may be
deleted or renamed in git repo;

2) There are no path/to/foo.c for path/to/foo.o which is
normal, we should add those files to exception list.

I got much fewer of such warning when I tested it.
