Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2F1RC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 13:02:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab2F1RC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 13:02:56 -0400
Date: Fri, 29 Jun 2012 02:02:53 +0900 (JST)
Message-Id: <20120629.020253.963694178693689545.yamato@redhat.com>
To: andrei.emeltchenko.news@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/8] /proc/net/ entries for bluetooth protocols
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20120618082826.GA2898@aemeltch-MOBL1>
References: <20120615080007.GD7205@aemeltch-MOBL1>
	<20120617.092637.2171077367789127221.yamato@redhat.com>
	<20120618082826.GA2898@aemeltch-MOBL1>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrei

Could you review my v2 patch set I submitted?

      https://lkml.org/lkml/2012/6/18/170

Masatake YAMATO

      
> Hi Masatake,
> 
> On Sun, Jun 17, 2012 at 09:26:37AM +0900, Masatake YAMATO wrote:
>> Hi,
>> 
>> Thank you for reviewing.
>> I have a question.
>> 
>> >> +		sk = sk_entry(v);
>> >> +		bt = bt_sk(sk);
>> >> +		seq_printf(seq, "%pK %-6d %-6u %-6u %-6u %-6lu",
>> >> +			   sk,
>> >> +			   atomic_read(&sk->sk_refcnt),
>> >> +			   sk_rmem_alloc_get(sk),
>> >> +			   sk_wmem_alloc_get(sk),
>> >> +			   sock_i_uid(sk),
>> >> +			   sock_i_ino(sk)
>> >> +			);
>> >> +		seq_puts(seq, batostr(&bt->src));
>> > 
>> > batostr looks OK now but this will be outdated soon by %pMR.
>> 
>> As far as reading Documentation/printk-formats.txt and 
>> pointer() in lib/vsprintf.c, %pMR is not defined.
>> I guess you mean %pM, don't you?
> 
> Sorry for confusion, I meant my patch adding new printf specifier which
> is not yet in the tree. I think it will take longer time to be accepted 
> then your patch.
> 
>> I've tried following code, and it works as expected.
>> 
>> 		baswap(&src_baswapped, &bt->src);
>> 		baswap(&dst_baswapped, &bt->dst);
>> 
>> 		seq_printf(seq, "%pK %-6d %-6u %-6u %-6u %-6lu %pM %pM %-6lu",
>> 			   sk,
>> 			   atomic_read(&sk->sk_refcnt),
>> 			   sk_rmem_alloc_get(sk),
>> 			   sk_wmem_alloc_get(sk),
>> 			   sock_i_uid(sk),
>> 			   sock_i_ino(sk),
>> 			   &src_baswapped,
>> 			   &dst_baswapped,
>> 			   bt->parent? sock_i_ino(bt->parent): 0LU);
>>
> 
> Please use whatever method best suits for you although I prefer second
> solution since it is easier to change to %pMR later.
> 
> Best regards 
> Andrei Emeltchenko 
> 
