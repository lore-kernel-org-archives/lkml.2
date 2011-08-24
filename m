Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab1HXWIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:08:42 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:38459 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1HXWIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:08:41 -0400
Date: Wed, 24 Aug 2011 18:08:37 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: base support for the TS-5500 platform
Message-ID: <20110824180837.6841f3d8@v0nbox>
In-Reply-To: <4E55670F.90102@zytor.com>
References: <1314217407-31249-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314217407-31249-2-git-send-email-vivien.didelot@savoirfairelinux.com>
	<4E55670F.90102@zytor.com>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 14:03:11 -0700,
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/24/2011 01:23 PM, Vivien Didelot wrote:
> > +
> > +/**
> > + * ts5500_pre_detect() - check for TS-5500 specific features
> > + *
> > + * It is not safe to read ID register if we are not sure that it's
> > a TS SBC.
> > + * Since TS SBCs don't have DMI support, it is safer to check for
> > a TS-5500
> > + * specific feature such as the processor.
> > + */
> > +static int ts5500_pre_detect(void)
> > +{
> > +	/* Check for AMD ElanSC520 Microcontroller */
> > +	if (!(cpu_info.x86_vendor == X86_VENDOR_AMD &&
> > +	      cpu_info.x86 == AMD_ELAN_FAMILY &&
> > +	      cpu_info.x86_model == AMD_ELAN_SC520))
> > +		return -ENODEV;
> > +
> > +	return 0;
> > +}
> > +
> 
> Doesn't this mean you will read this unsafe register on any Elan SC520
> platform?  Is that okay?
> 
> 	-hpa
> 
Indeed this will be run on any Elan SC520 based platforms if the user
has asked for TS-5500 support in the menuconfig. I could add checks for
other hardware such as the Ethernet controller, but it would require
including pci headers and delaying the initcall (using late_initcall
instead of postcore_initcall).
That's why I think it is not really worth adding more tests. They
could be added later in this function if there is really a need.

Regards,
Vivien.
