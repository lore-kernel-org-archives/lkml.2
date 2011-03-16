Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab1CPDqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 23:46:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62897 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1CPDq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 23:46:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=I0+88jCJ94eDLHcuVjCrPy+9GaeZdQAPwD4qOEZ8Ia8g54msoRmXl0qwP4e0G2xhRl
         v6EtilePtZg9EthU8yfwNRonbRKApV9blD07eN6jzm26IIDlVKqSBbAPpGlPoK5FD7YF
         QKzVMChTVXPfE1Qkd23S+PfaqtkVnpxIGPs28=
MIME-Version: 1.0
In-Reply-To: <b7da2f$qnp1ps@fmsmga001.fm.intel.com>
References: <1298404994-2907-1-git-send-email-mjg@redhat.com>
	<1300125566-29648-1-git-send-email-chris@chris-wilson.co.uk>
	<cb03c0cd31393b476e63c4e699247c91.squirrel@webmail.greenhost.nl>
	<b7da2f$qnp1ps@fmsmga001.fm.intel.com>
Date: Wed, 16 Mar 2011 13:46:27 +1000
Message-ID: <AANLkTinexavArS+V2APjxrqMeLSzgs8QiyGAEhtWR0mh@mail.gmail.com>
Subject: Re: [PATCH] ACPI/Intel: Rework Opregion support
From: Dave Airlie <airlied@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Indan Zupancic <indan@nul.nu>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Read the changelog and thread on the patch that disabled this logic, the
> failure (or at least inconsistent behaviour with the expectations of the
> HP BIOS authors) appears to be in how we initialise ACPI on the HP
> machines that causes the initial value of lid state to be incorrect. Since
> one of the laptops that Dave tests drm-next on is a HP, he was bitten by
> the bug and temporarily (we hope) disabled the logic. Or else once again,
> we will continue to light up the panel on a closed laptop.

Yeah I've no idea if the ACPI implementation is wrong or not :-(

I suspects its the BIOS actually, the BIOS wants _INI called before _REG.
The ACPI video device isn't in the EC address space, so it ends up in the
default region address space. So we'd really need to know how Windows
sets up the _REG calls for the non-EC spaces and where its calls the _INI
methods wrt to that.

The thing is I think the actual ACPI lid device is fine, its just opregion isn't
updated until we get an event later.

Dave.
