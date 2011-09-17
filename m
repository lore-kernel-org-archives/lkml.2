Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab1IQXiC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 19:38:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56134 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123Ab1IQXiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 19:38:00 -0400
MIME-Version: 1.0
In-Reply-To: <20110917191221.GA24295@rhlx01.hs-esslingen.de>
References: <CAErB21iHz_ToVzfU8aPkY8OW5iMOTPgPMdQBsmxo=5YUCMb6Aw@mail.gmail.com>
	<20110917191221.GA24295@rhlx01.hs-esslingen.de>
Date: Sat, 17 Sep 2011 19:37:59 -0400
Message-ID: <CAMzpN2gNtnRVPreeeUVOCr7_t5j6xx+YGHeJkAgqTS2PyUibbw@mail.gmail.com>
Subject: Re: TLB flush question (x86_64)
From: Brian Gerst <brgerst@gmail.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Arkaprava Basu <arkaprava.basu@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 3:12 PM, Andreas Mohr <andi@lisas.de> wrote:
> Hi,
>
> decided to reply since there hasn't been any activity yet.
>
>> Is there any particular reason why
>> the entire address space is flushed from the tlb while only a range of
>> virtual address space was supposedly required to be flushed?
>
> While this particular function has actually changed in less medieval
> kernel versions, it would be nice if someone knew an answer to that,
> especially since TLB activity may have grave performance implications.
>

x86 hardware can only flush single pages or the whole TLB.  It would
be possible to loop over a small set of pages and invalidate each one,
but the threshold for where that becomes more efficient than flushing
everything is difficult to determine.

--
Brian Gerst
