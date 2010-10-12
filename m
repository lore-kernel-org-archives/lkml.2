Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab0JLLVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 07:21:04 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40445 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0JLLVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 07:21:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JoMkBuKRoCty6+KQSFrGbV1g83Fwe6dcTCRAMfWmjNAxnQmVKuPuH/yuGYo4gPtUcg
         ZybWlgM9Dndwf91IYCcj3k+Gevf/5eHCTqhoOu2M7t5BUx62G8kBhfdpIcxkmPl3azy8
         LAqWejVK15IEXEc25eyHkAqt9JkVMO3wCzKXc=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F47B2BB1@dlee06.ent.ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
	<AANLkTimoTmhAw11jJihiuyByzKZ9KTFHvx6iw8oeLCGg@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F47B2BB1@dlee06.ent.ti.com>
Date: Tue, 12 Oct 2010 14:20:59 +0300
Message-ID: <AANLkTim6XRgnefA0vmRNeW=TONhxz68WYAjuA96LqWOj@mail.gmail.com>
Subject: Re: [PATCHv3 00/11] staging tidspbridge: iommu migration
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "ameya.palande@nokia.com" <ameya.palande@nokia.com>,
        "Menon, Nishanth" <nm@ti.com>,
        "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "ohad@wizery.com" <ohad@wizery.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andy.shevchenko@gmail.com" <andy.shevchenko@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 6:03 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> On Tue, Oct 5, 2010 at 11:35 PM, Fernando Guzman Lugo
>> <x0095840@ti.com> wrote:
>> > This set of patches remove the dspbridge custom mmu
>> implementation and
>> > use iommu module instead.
>>
>> I have tried this, it works for simple tests, but not real use-cases.
>> I applied all your iommu patches. How did you test this?
>
> Have you applied:
>
> - "scatterlist: define SG chain for arm architecture"
> - "iovmm: replace __iounmap with omap_iounmap"
> - "iovmm: add superpages support to fixed da address"
> - "iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF"
> - "iovmm: no gap checking for fixed address"

Yes.

> Also make sure your baseline have this patch:
>
> - "omap:iommu-load cam register before flushing the entry"

Huh? That's not even in v2.6.36-rc7, in which baseline is this
supposed to be in? Anyway, I'll try adding that.

> What kind of error are you getting?

Node allocation failing IIRC.

> I don't have a complete framework to test MM testcases at this moment

See:
http://felipec.wordpress.com/2010/10/08/my-arm-development-notes/

I even prepared a tarball so you just need to extract it on your
device. It's not difficult to test this with GStreamer, and I don't
see how you can be confident that they indeed work without testing
some real use-cases. Anyway, I'll try that missing patch.

Cheers.

-- 
Felipe Contreras
