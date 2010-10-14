Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0JNOTB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:19:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49985 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab0JNOTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:19:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IEwVIwyiOZbeeHudergFTRl94A71qffiOlBp56wM1XbMvZreYeLzL2Qfb83ckayX3I
         oeA0vTKIowPBDJ2W+/z8KMro8dpFVVzlTi5bYIsxq6zxh0+w1LKpBOF+o8oJjoUBbhHa
         XeY5R1IXQ/r0kbwayZJZq8QVBZav0Gffphiag=
MIME-Version: 1.0
In-Reply-To: <496565EC904933469F292DDA3F1663E602F47B3002@dlee06.ent.ti.com>
References: <1286310944-25035-1-git-send-email-x0095840@ti.com>
	<AANLkTimoTmhAw11jJihiuyByzKZ9KTFHvx6iw8oeLCGg@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F47B2BB1@dlee06.ent.ti.com>
	<AANLkTim6XRgnefA0vmRNeW=TONhxz68WYAjuA96LqWOj@mail.gmail.com>
	<496565EC904933469F292DDA3F1663E602F47B3002@dlee06.ent.ti.com>
Date: Thu, 14 Oct 2010 15:27:13 +0300
Message-ID: <AANLkTik3hhWy+tRxThtrbwNXTssV7nf9+_LGn5Ct3iet@mail.gmail.com>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 5:39 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
>> On Mon, Oct 11, 2010 at 6:03 PM, Guzman Lugo, Fernando
>> <fernando.lugo@ti.com> wrote:
>> >> On Tue, Oct 5, 2010 at 11:35 PM, Fernando Guzman Lugo
>> >> <x0095840@ti.com> wrote:
>> >> > This set of patches remove the dspbridge custom mmu
>> >> implementation and
>> >> > use iommu module instead.
>> >>
>> >> I have tried this, it works for simple tests, but not real
>> use-cases.
>> >> I applied all your iommu patches. How did you test this?
>> >
>> > Have you applied:
>> >
>> > - "scatterlist: define SG chain for arm architecture"
>> > - "iovmm: replace __iounmap with omap_iounmap"
>> > - "iovmm: add superpages support to fixed da address"
>> > - "iovmm: IVA2 MMU range is from 0x11000000 to 0xFFFFFFFF"
>> > - "iovmm: no gap checking for fixed address"
>>
>> Yes.
>>
>> > Also make sure your baseline have this patch:
>> >
>> > - "omap:iommu-load cam register before flushing the entry"
>>
>> Huh? That's not even in v2.6.36-rc7, in which baseline is
>> this supposed to be in? Anyway, I'll try adding that.
>
> That's is in latest Hiroshi's tree and it is really needed, Otherwise
> You will have wrong traslations which can cause unexpected behavior.

Now I applied that, still fails.

>> > What kind of error are you getting?
>>
>> Node allocation failing IIRC.
>
> Is it falling to map the Heap??
> I mean you see this trace?
>
>        if (status)
>                pr_err("%s: Failed to map memory for Heap: 0x%x\n",
>                       __func__, status);
>
> Otherwise, I don't see how that fail is related with iommu changes.

Nope.

>> > I don't have a complete framework to test MM testcases at
>> this moment
>>
>> See:
>> http://felipec.wordpress.com/2010/10/08/my-arm-development-notes/
>>
>> I even prepared a tarball so you just need to extract it on
>> your device. It's not difficult to test this with GStreamer,
>> and I don't see how you can be confident that they indeed
>> work without testing some real use-cases. Anyway, I'll try
>> that missing patch.
>
> Most of time real use-cases are not so stressing like testcases
> We can make to test under real stress in order to find out corner cases.
> However when I test it was pretty stable and just few erros because staging
> Does not have latest mailbox patches. Also I test in a .35 version of staging.
> So now I am using a branch with all new patches and I will recheck and test
> Again any possible issue. Also I will look at your gstreamer fail too.

Well, in my experience it's the other way around, the stress
test-cases don't catch the errors that happen on real use-case
scenarios, no matter how extensive they are. This is a good example.

Cheers.

-- 
Felipe Contreras
