Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030510Ab2HPVbE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:31:04 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:55863 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030362Ab2HPVbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:31:01 -0400
Message-ID: <502D6691.5010101@gmail.com>
Date: Thu, 16 Aug 2012 14:30:57 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
CC: herbert@gondor.hengli.com.au, linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: on stack dynamic allocations
References: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
In-Reply-To: <CALLzPKYzc5FwPFTn5Ztg58vfkMO2EZ8P-MLEmVXRqdBE+CkkSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2012 02:20 PM, Kasatkin, Dmitry wrote:
> Hello,
>
> Some places in the code uses variable-size allocation on stack..
> For example from hmac_setkey():
>
> 	struct {
> 		struct shash_desc shash;
> 		char ctx[crypto_shash_descsize(hash)];
> 	} desc;
>
>
> sparse complains
>
> CHECK   crypto/hmac.c
> crypto/hmac.c:57:47: error: bad constant expression
>
> I like it instead of kmalloc..
>
> But what is position of kernel community about it?

If you know that the range of crypto_shash_descsize(hash) is bounded, 
just use the upper bound.

If the range of crypto_shash_descsize(hash) is unbounded, then the stack 
will overflow and ... BOOM!

David Daney



