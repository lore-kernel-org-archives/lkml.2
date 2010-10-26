Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0JZBqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:46:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52988 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab0JZBqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ev3gFKvhnyJLoxtw8LPzF78eAuPeWYmxeZIl1t4M/O3wPCi7QR5Z/MjpBGRyqfjOnv
         GKiB4MkyliOZo/DMZOrMKokQDjwmQ1hgjEWvYzQ1nnJ+VjFnMVNdAA5+faPZcx/k6FhL
         wqTiKm/J13TV5Av1ukW9vdegSyjITKojVT5vg=
Subject: Re: [PATCH 05/29] memstick: mspro_block: move declarations to
 header and refactor things a bit
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <707256.89727.qm@web37601.mail.mud.yahoo.com>
References: <707256.89727.qm@web37601.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 03:46:16 +0200
Message-ID: <1288057576.4024.90.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 08:07 -0700, Alex Dubov wrote:
> --- On Fri, 22/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > Subject: [PATCH 05/29] memstick: mspro_block: move declarations to header and refactor things a bit
> > To: "Alex Dubov" <oakad@yahoo.com>
> > Cc: "Andrew Morton" <akpm@linux-foundation.org>, "LKML" <linux-kernel@vger.kernel.org>, "Maxim Levitsky" <maximlevitsky@gmail.com>
> > Received: Friday, 22 October, 2010, 4:53 PM
> > This makes it much easier to lookup
> > things and reduces size of mspro_block.c
> 
> Subjective and irrelevant.
> My editor makes it easier to look up things when they are in the same file,
> and this declarations are not expected to be used by any other compilation
> unit. Belongs to the cosmetic category which should be discussed later.
I agree that it is subjective.
However when you have 2 files, you can always open them in different
copies of an editor, terminal tabs.
When you have decorations in one file you depend on the editor a lot.
also its not about finding them.
Its about distrupting the workflow, because once you find the
declaration you need to find the place you were before.
I understand that some editors help with that, yea.


> 
> > Also add debbuging macros so that it becames possible to
> > control
> > debbuging via module param.
> > 
> 
> Should be done through a common kernel infrastructure, namely DYNAMIC_DEBUG
> feature (pr_debug and friends).
How a user can turn DYNAMIC_DEBUG on?
How about different levels of verbosity?
Last time I checked DYNAMIC_DEBUG doesn't allow that.
Besides the macros I add revert to 
DYNAMIC_DEBUG if user doesn't specify the debug= module param.

When dynamic debugs grows that features (I have seen a ddebug= patchset,
hope it gets merged, I will just trim down these macros).
Besides the goal of these macros is to reduce typing.
I need to add/remove the debug printouts very often, and then I don't
want even to type that '\n' at the end.
Besides, a lot of drivers are doing that. Just look around.

I already added similiar looking macros to 2 my other driver
 (r852 sm_ftls and ene_cir) and no complains.

Best regards,
	Maxim Levitsky

