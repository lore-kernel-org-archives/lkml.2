Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab1BKHjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 02:39:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab1BKHjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 02:39:13 -0500
Message-ID: <4D54E753.9090906@redhat.com>
Date: Fri, 11 Feb 2011 08:37:55 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-kernel@vger.kernel.org, Alexander Kjeldaas <astor@fast.no>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: NULL deref in drivers/md/dm-crypt.c:crypt_convert()
References: <alpine.LNX.2.00.1102062320230.13593@swampdragon.chaosbits.net> <4D4F25A3.1090401@redhat.com> <alpine.LNX.2.00.1102102004140.26035@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102102004140.26035@swampdragon.chaosbits.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2011 08:14 PM, Jesper Juhl wrote:
> On Sun, 6 Feb 2011, Milan Broz wrote:
> 
> If you have a coverity scan account it is CID 40766. But since you ask I 
> assume you do not have an account, so I've also pasted the output from 
> their web interface here :

Thanks.

I would say that the checker has problem to follow per cpu pointers...

In this case
static struct crypt_cpu *this_crypt_config(struct crypt_config *cc)
{
        return this_cpu_ptr(cc->cpu);

Otherwise it must see that the struct is allocated in
crypt_alloc_req(cc, ctx);

And mempool allocation should never return NULL here.

Milan
