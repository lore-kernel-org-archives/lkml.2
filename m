Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1DTNEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713Ab1DTNEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:04:49 -0400
Message-ID: <4DAED9EC.5080604@redhat.com>
Date: Wed, 20 Apr 2011 16:04:44 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Nelson Elhage <nelhage@ksplice.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: emulator: Use linearize() when fetching instructions.
References: <1303142753-24562-1-git-send-email-nelhage@ksplice.com>
In-Reply-To: <1303142753-24562-1-git-send-email-nelhage@ksplice.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2011 07:05 PM, Nelson Elhage wrote:
> Since segments need to be handled slightly differently when fetching
> instructions, we add a __linearize helper that accepts a new 'fetch' boolean.

>   static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
>   			      struct segmented_address addr,
>   			      void *data,
> @@ -637,11 +646,13 @@ static int do_fetch_insn_byte(struct x86_emulate_ctxt *ctxt,
>   	int size, cur_size;
>
>   	if (eip == fc->end) {
> -		unsigned long linear = eip + ctxt->cs_base;
> -		if (ctxt->mode != X86EMUL_MODE_PROT64)
> -			linear&= (u32)-1;
> +		unsigned long linear;
> +		struct segmented_address addr = {VCPU_SREG_CS, eip};
>   		cur_size = fc->end - fc->start;
>   		size = min(15UL - cur_size, PAGE_SIZE - offset_in_page(eip));

Breaks immediately - the segmented_address initializer is backwards.  
I've fixed this in my tree.

-- 
error compiling committee.c: too many arguments to function

