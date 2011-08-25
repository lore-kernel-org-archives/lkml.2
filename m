Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1HYQJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:09:22 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49919 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1HYQJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110826015111.49af16f792d5554fd931d230@canb.auug.org.au>
References: <20110825161843.daf46b6b4023926fcfeec387@canb.auug.org.au>
	<20110825140820.GA9126@kroah.com>
	<4E56689D.3080202@freescale.com>
	<20110826015111.49af16f792d5554fd931d230@canb.auug.org.au>
Date: Thu, 25 Aug 2011 12:09:20 -0400
Message-ID: <CACqU3MUs_97=MuuKAjr-LeUT7kSRxtzSntwUeKeeH4n8s7SSGg@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty tree related)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Timur Tabi <timur@freescale.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 25, 2011 at 11:51 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Timur,
>
> On Thu, 25 Aug 2011 10:22:05 -0500 Timur Tabi <timur@freescale.com> wrote:
>>
>> Is there some trick to building allyesconfig on PowerPC?  When I do try that, I
>> get all sorts of weird build errors, and it dies long before it gets to my
>> driver.  I get stuff like:
>>
>>   LD      arch/powerpc/sysdev/xics/built-in.o
>> WARNING: arch/powerpc/sysdev/xics/built-in.o(.text+0x1310): Section mismatch in
>> reference from the function .icp_native_init() to the function
>> .init.text:.icp_native_init_one_node()
>> The function .icp_native_init() references
>> the function __init .icp_native_init_one_node().
>> This is often because .icp_native_init lacks a __init
>> annotation or the annotation of .icp_native_init_one_node is wrong.
>
> We get lots of those in many builds. :-(  Just a warning.
>
If you could provide an exhaustive list of them, I'd be interested. Do
you account/reference them in the report you make on each new -next
tree ?

 - Arnaud

>> and
>>
>>   AS      arch/powerpc/kernel/head_64.o
>> arch/powerpc/kernel/exceptions-64s.S: Assembler messages:
>> arch/powerpc/kernel/exceptions-64s.S:1151: Error: attempt to move .org backwards
>> arch/powerpc/kernel/exceptions-64s.S:1160: Error: attempt to move .org backwards
>
> There is a patch for that pending with either the kvm guys or the powerpc guys.
>
>> I guess I don't have the right compiler.
>
> Yours seems to be OK.  If you pass -k to make it will get further.  Or
> you could configure it and then just try building your driver rather than
> the whole tree.
>
>> Anyway, I think I know how to fix the break that Stephen is seeing.  I will post
>> a v4 patch in a few minutes.
>
> Thanks.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
