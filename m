Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1DOQLa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:11:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65095 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1DOQL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XxGRa7L0D3tPHRxkCZxxXVR6+QnVZlSIJUtakAGaFCn3Wfd6OZomfkbAUphzCut8f5
         Lzk5NS4FiEJU/6t31xGTuKNRBlFWH2W/l3grde3DEVPKP8xjqkbo4QvvDQlwNIxUGtE8
         TbFPvaHaIgcMACLjzq4EEKU9iCkRd+7w1O/hI=
MIME-Version: 1.0
In-Reply-To: <20110415154604.GN18463@8bytes.org>
References: <20110413193459.GL19819@8bytes.org>
	<4DA60C30.4060606@kernel.org>
	<BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
	<4DA6145D.9070703@kernel.org>
	<BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
	<4DA655E7.3000904@zytor.com>
	<BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
	<BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
	<20110415131152.GJ18463@8bytes.org>
	<20110415131650.GB18660@elte.hu>
	<20110415154604.GN18463@8bytes.org>
Date: Fri, 15 Apr 2011 12:11:28 -0400
Message-ID: <BANLkTim23SQiyb4R+QA7=fpPZrnQw9_PRQ@mail.gmail.com>
Subject: Re: Linux 2.6.39-rc3
From: Jerome Glisse <j.glisse@gmail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        alexandre.f.demers@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:46 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Fri, Apr 15, 2011 at 03:16:50PM +0200, Ingo Molnar wrote:
>> Ok, but how did the allocation changes start triggering this error in
>> v2.6.39-rc1? There must still be some layout specific thing here, right?
>> Do we understand the details of that as well?
>
> Well, thinking again about this, the GPU likely generated this DMA
> request before too (which has an address in the range configured for the
> GTT on the card), but nobody noticed because they just hit main memory.
> And with the allocation changes in 39-rc1 the GART aperture started to
> be on the same address as the GTT (in their respective address spaces)
> so that the DMA request hit the GART. This caused the MCE and the
> sync-flood.
> The open question is why the GPU generates a DMA request with an address
> that is configured as the GTT base (+1 page) on the card.
>
>        Joerg
>

Do you also got the write if you load radeon with radeon.no_wb=1 ?
I think at this address it's the wb page, or maybe the cp as wb likely
take only one page

Cheers,
Jerome
