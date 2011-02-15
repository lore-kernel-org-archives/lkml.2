Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1BOArn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 19:47:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46884 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1BOArk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 19:47:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Jd8Ra4DUE/zHwp3dEvWyJ5mtipV58mbViUQaVgYhSApYSOXO5noEA4r2EEIHDR0d0I
         PeChBc8VPIxz9g/Glv58bbrrqYQBcKQnHoKCDrvzc6OShQ9Rq5HSJ8sz5MVSyxSF0mEv
         lwfpSKdeMzgnPU1mZYfDhbQSFV7lbdyFhrnXw=
Message-ID: <4D59CD28.7070108@gmail.com>
Date: Mon, 14 Feb 2011 18:47:36 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: ak@linux.intel.com, cebbert@redhat.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org
Subject: Re: b44 driver causes panic when using swiotlb
References: <4D4759BD.2000006@gmail.com>	<20110201102707C.fujita.tomonori@lab.ntt.co.jp>	<4D477C6F.8000906@gmail.com> <20110201142103M.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20110201142103M.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 11:22 PM, FUJITA Tomonori wrote:
> On Mon, 31 Jan 2011 21:22:23 -0600
> Robert Hancock<hancockrwd@gmail.com>  wrote:
>
>>> Some ideas to implement something that works for such device were
>>> discussed. Seems that the conclusion is that it's doesn't worth making
>>> the common code complicated for such minor and insane devices.
>>
>> I don't think this is the only device that has sub-32-bit DMA
>> restrictions, this will just lead to a bunch of duplicated code.
>
> Yeah, not only device but not many.
>
> The block layer has the own bouncing mechanism. Some network drivers
> have the similar bouncing code. I don't know if there are other kinds
> of drivers that have the own bouncing code.
>
> I thought that we can make mm/bounce.c (used for block drivers now)
> work any drivers without complicating it. We could make swiotlb to do
> but it's too complicated and it doesn't worth.
>
>
>> In
>> particular, how is LPC DMA supposed to work?
>
> LPC DMA can't do 32bit dma?

At least not if it's using ISA-style 3rd-party DMA. Some devices may do 
bus-mastering and be able to do 32-bit DMA, but I've never seen one, at 
least.

>
>
>> At the very least we should be allowing the driver to deal with the
>> failure instead of panicing the system. Otherwise we are just leaving a
>> land mine for people to trip over.
>
> Agreed. swiotlb shouldn't panic in this case. I'll take care of it.

