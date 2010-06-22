Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab0FVXxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:53:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43339 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab0FVXxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:53:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=J1Nc5H6ts/Lkb3usMaPRoL0u87ovams7PuadcyDu8Cx86B3vEo8EhNPyt3MzJmW9Et
         u3lugfPndLWVm24OWiSbBIu9lP3PVYGvnL7mI73IBMtId/Zahyi2jK0wVjYnpnOsPtnJ
         NFIhy3AI6Klauwyum26vWNRuWcyh45Ii0VyZg=
MIME-Version: 1.0
In-Reply-To: <1277072356-18048-1-git-send-email-linus.walleij@stericsson.com>
References: <1277072356-18048-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 22 Jun 2010 16:53:45 -0700
X-Google-Sender-Auth: _9E7YiGfQusBbmcYrrZb4w09DNI
Message-ID: <AANLkTikRRVPijSpkG8elztu_PS1p_0XM_fhiVrWOTqxZ@mail.gmail.com>
Subject: Re: [PATCH] DMAENGINE: runtime config for slave channels
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 3:19 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> This adds an interface to the DMAengine to make it possible to
> reconfigure a channel at runtime. We add a few foreseen config
> parameters to the passed struct, with a void * pointer for custom
> per-device or per-platform data.
>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> OK at night I realized that maybe what we do for runtime
> re-configuration of DMA for the AMBA PrimeCells is actually generic
> and should maybe be lifted into the DMAengine instead.
>
> This conclusion came from Viresh stating that the SPEAr platform
> will need runtime reconfiguration for other things than PrimeCells,
> (on the PL08x driver) and actually we will likely need it ourselves
> too.
>
> So before starting to abuse that PrimeCell interface for things
> not PrimeCell, this way I suggest making this generic from day 1.
>
> Doing so makes it possible for me to merge the runtime
> re-configuration support for DMA40, COH 901 318 and the current
> iteration of the PL08x driver as well, and break that out of the
> PrimeCell series and drop the include/linux/amba/dma.h entirely
> while still getting some real nice and generic functionality
> in place.
>
> The PrimeCell patchset can then be nicely wrapped around this.
>
> More genric run-time configurations can be added to the struct if
> they are really generic like these, else the private_config can
> be used for local obscurities.
>
> Need your help on how to proceed on this one Dan.

Is there a guarantee that all devices that implement this command will
support all the fields?  The presence of private_config concerns me
because that still seems to imply some hard coded knowledge about the
specific dma engine from the client.

...which is fine, but only if this is a common way to express
arch-specific extensions.  In other words it's not clear where the
line is drawn between "this is a common operation that different dma
drivers can use / extend incompatibly" versus "this truly a generic
api that a client driver can depend on to run unmodified across
architectures that have a supporting dma driver".  Clarifying that
would help end point device driver authors to know what they can rely
on... to date all the slave implementations have been written by the
same author who wrote the driver, so the information hiding has been
blurred.  It would be nice to define / document what is and is not
expected to work for this command across implementations.

--
Dan
