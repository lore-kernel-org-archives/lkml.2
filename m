Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2DRRYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 13:24:38 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59211 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2DRRYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 13:24:35 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1204181216380.2542@ionos>
References: <CADDKRnBpGr=yzDftChA3xiaK9gK4D4UDV6HJiw8hcMo6159+Cw@mail.gmail.com>
 <20120402235412.GD16303@tassilo.jf.intel.com> <alpine.LFD.2.02.1204031001510.2542@ionos>
 <CADDKRnAOqfxTjrCp4E5eKFJvVTu6s0xF3Ca3jRJavFkyGpYLmQ@mail.gmail.com>
 <alpine.LFD.2.02.1204121055200.2542@ionos> <20120412142904.GA4130@srcf.ucam.org>
 <alpine.LFD.2.02.1204121903250.2542@ionos> <alpine.LFD.2.02.1204121907330.2542@ionos>
 <4F872C7B.6000106@linux.intel.com> <alpine.LFD.2.02.1204122241460.2542@ionos>
 <1334741105.1924.5.camel@x61.thuisdomein> <alpine.LFD.2.02.1204181216380.2542@ionos>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Apr 2012 10:24:13 -0700
X-Google-Sender-Auth: 60VTOmlR_KgN2h-yfI3gE_LcqtY
Message-ID: <CA+55aFyHgQ8QgfLKaCaAJ2gLMrOkFMkQBtt4Bfo=dOzzxSpGHw@mail.gmail.com>
Subject: Re: [v3.4-rc1] ACPI regression bisected
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul Bolle <pebolle@tiscali.nl>, Andi Kleen <ak@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 3:29 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Linus, can you please apply directly?

Applied. Can we perhaps also make request_threaded_irq() noisily
reject things that are not marked IRQF_ONESHOT and have a NULL
low-level handler?

That still allows people to do IRQF_SHARED | IRQF_ONESHOT, and that
won't be rejected until somebody else actually tries to share it. Then
it breaks that somebody else ;(

Sadly, that would tend to break fairly silently.

I wonder if we should make the mismatch error printout be
unconditional (and make just the "dump_stack()" part be conditional on
CONFIG_DEBUG_SHIRQ)?

                 Linus
