Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0LQEBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 23:01:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:41181 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab0LQEBB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 23:01:01 -0500
References: <20101207105053.GA2803@redhat.com> <4CFE89FE.1090901@kernel.org> <20101208141942.GA2335@redhat.com> <4D00823A.9050808@kernel.org> <20101209124117.GA6032@redhat.com> <4D01377B.5070809@kernel.org> <20101213100848.GA2237@redhat.com> <4D0663F0.2060103@kernel.org> <4D06783C.6040009@zytor.com> <20101214224135.GB19693@redhat.com> <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <4D0AD976.3020504@zytor.com>
In-Reply-To: <4D0AD976.3020504@zytor.com>
Mime-Version: 1.0 (iPhone Mail 8C148)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
X-Mailer: iPhone Mail (8C148)
From: Yinghai <yinghai@kernel.org>
Subject: Re: kdump broken on 2.6.37-rc4
Date: Thu, 16 Dec 2010 19:58:48 -0800
To: "H. Peter Anvin" <hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please don't do that to 64 bit

My big system with 1024g memory and a lot of cards with rhel 6 to make kdump work must have crashkernel=512m and second kernel need to take pci=nomsi

Thanks

On Dec 16, 2010, at 7:31 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 12/15/2010 08:29 PM, Yinghai Lu wrote:
>> please check
>> 
>> [PATCH] x86, crashkernel, 32bit: only try to get range under 512M
>> 
>> Steanishlaw report kdump is 32bit is broken.
>> 
>> in misc.c for decompresser, it will do sanity checking to make sure heap
>> heap under 512M.
>> 
>> So limit it in first kernel under 512M for 32bit system.
>> 
>> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> 
>> ---
>> arch/x86/kernel/setup.c |   14 +++++++++++++-
>> 1 file changed, 13 insertions(+), 1 deletion(-)
>> 
> 
> I'd like to apply a modified version of this patch (attached.)
> 
> Ack/nak, people?
> 
>    -hpa
> <0001-x86-kexec-Limit-the-crashkernel-address-to-512-MiB.patch>
