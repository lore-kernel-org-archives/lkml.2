Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab2BJCT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 21:19:28 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64631 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2BJCTZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 21:19:25 -0500
MIME-Version: 1.0
In-Reply-To: <1328832518.2404.86.camel@zim.stowe>
References: <20120209163641.26858.59399.stgit@amt.stowe> <CAErSpo47+kHmS6477Bne84rPiy+sHGjgtK3mpk6VJc+hM4hhbg@mail.gmail.com>
 <1328832518.2404.86.camel@zim.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 9 Feb 2012 18:19:03 -0800
Message-ID: <CAErSpo6L54td2SVm7LR_aSfseiRL4kOnf0ObnuO0QquYzAj+iQ@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Fix logic for removing mappings in 'acpi_unmap'
To: Myron Stowe <mstowe@redhat.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, lenb@kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com, tony.luck@intel.com,
        trenn@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 4:08 PM, Myron Stowe <mstowe@redhat.com> wrote:
> On Thu, 2012-02-09 at 08:42 -0800, Bjorn Helgaas wrote:
>> On Thu, Feb 9, 2012 at 8:36 AM, Myron Stowe <myron.stowe@redhat.com> wrote:
>> > From: Myron Stowe <mstowe@redhat.com>
>> >
>> > Make sure the removal of mappings uses the same logic that put the
>> > mappings in place.
>> >
>> > Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>> > ---
>> >
>> >  drivers/acpi/osl.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
>> > index 412a1e0..5aef087 100644
>> > --- a/drivers/acpi/osl.c
>> > +++ b/drivers/acpi/osl.c
>> > @@ -347,7 +347,7 @@ static void acpi_unmap(acpi_physical_address pg_off, void __iomem *vaddr)
>> >        unsigned long pfn;
>> >
>> >        pfn = pg_off >> PAGE_SHIFT;
>> > -       if (page_is_ram(pfn))
>> > +       if (should_use_kmap(pfn))
>> >                kunmap(pfn_to_page(pfn));
>> >        else
>> >                iounmap(vaddr);
>> >
>>
>> Whatever happened to the question of why we have arch-specific
>> ioremap() behavior?  It's good to make map/unmap symmetric, but it'd
>> be better to get rid of the ioremap/kmap hack.
>
> +cc ingo
>
> We never received any explanation for why ioremap() failed for Ying with
> RAM on x86.  Last I saw Ying asked Ingo for some input here but there
> was never any reply -
> http://marc.info/?l=linux-acpi&m=132788392604738&w=2
>
> I like your idea of possibly changing ioremap's implementation so that
> it would handle requests related to RAM - by using kmap() internally
> when necessary - so that a *user* wouldn't need to care what
> architecture we're on.  I, however, feel like I don't have enough
> experience with the memory management subsystem to know if such a tactic
> would fly or not so was uncomfortable proceeding along those lines.  As
> a result, I just wanted to get this in for the meantime.

I dunno if you're comfortable with it, but you can always propose a
patch doing it how you think it should be done.  People are more apt
to respond to a concrete patch than to an abstract question about why
things are the way they are.

Bjorn
