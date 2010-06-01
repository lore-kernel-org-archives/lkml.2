Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab0FABqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 21:46:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37108 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab0FABqT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 21:46:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=daPUvpaEnA539eapUZVYrEImRGkDT5zibZ1L5RWFyEdwiyBjrU2UKC1HOanYKwOtGQ
         KJmDOxTXwodGkft3gHN/xWF//rKWm8WWVMZ+v+2P6ykmbzkgiCoyujpMUHWQ9B5aRdfT
         yYK/Yta5Ej6K25MBczVw7S14i01473BuVv+iU=
MIME-Version: 1.0
In-Reply-To: <20100531220700.GA23076@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box>
	<4C03F04D.4040200@redhat.com>
	<20100531174225.GE10766@basil.fritz.box>
	<4C03FB8E.1060109@redhat.com>
	<20100531182724.GG10766@basil.fritz.box>
	<4C040636.8060702@redhat.com>
	<20100531190400.GH10766@basil.fritz.box>
	<20100531220700.GA23076@gondor.apana.org.au>
Date: Tue, 1 Jun 2010 09:46:17 +0800
Message-ID: <AANLkTimpMn0KJO8u2McP4Z56WeHXqmneFCKkq7BFjhrR@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
From: huang ying <huang.ying.caritas@gmail.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, Milan Broz <mbroz@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com, ak@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 6:07 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, May 31, 2010 at 09:04:00PM +0200, Andi Kleen wrote:
>> > I mean how it is implemented now in crypto API, and I was almost
>> > sure that aes-ni acceleration code uses cryptd (iow real asynchronous processing)
>> > and also that not all CPU cores can run these instruction in parallel.
>>
>> I think you can configure it to use cryptd (or pcrypt), but it's not default
>> and usually higher overhead.
>
> Right.  The only reason aes-ni uses the async interface is to
> work around the fact that you have to save FPU state when using
> it.  For dm-crypt you can consider it to be synchronous.

The reason for aes-ni to use async interface is that the FPU/SSE
instructions enclosed by kernel_fpu_begin and kernel_fpu_end is not
reentranceable. That is, it is not safe to use FPU/SSE instructions in
interrupt context, if the instructions are used in interrupted
context. So irq_fpu_usable is used in the async interface of aes-ni,
and go asynchronous implementation only if !irq_fpu_usable. In most
instances, the async interface of aes-ni will run in synchronous mode.

Best Regards,
Huang Ying
