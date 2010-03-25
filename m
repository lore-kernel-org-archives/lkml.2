Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab0CYMDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:03:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:28808 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0CYMD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:03:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QODLutlMAHBQDjgqsYE4tt4kAsB5K/V8AD/WQUWKlsWgbZLxM2qQQzj8LcLnTUjOcD
         45cbI+VMBWRM9Md8FNHMvq1lvQdCtLnOPswj2S204Hvg5g64g3UXLnPoamSmdAnI9IB5
         5sBYE4FLe1B9y39bi6Sf9NUT7MIzMYFoS6xxY=
MIME-Version: 1.0
In-Reply-To: <cd73a99e1003231326r7623bbc0icba163f9b2e0e96e@mail.gmail.com>
References: <20100203143736.564974126@gmail.com>
	 <20100203143803.528679118@gmail.com>
	 <cd73a99e1003231326r7623bbc0icba163f9b2e0e96e@mail.gmail.com>
Date: Thu, 25 Mar 2010 13:03:28 +0100
Message-ID: <6681f8e11003250503k20efc864ve6d916ad5a7c67b2@mail.gmail.com>
Subject: Re: [patch v3 2/3] at91_udc HW glitch
From: Harro Haan <hrhaan@gmail.com>
To: Andrew Victor <avictor.za@gmail.com>,
       Anti Sullin <anti.sullin@artecdesign.ee>
Cc: Ryan Mallon <ryan@bluewatersys.com>, Remy Bohmer <linux@bohmer.net>,
       Andrew Victor <linux@maxim.org.za>,
       David Brownell <dbrownell@users.sourceforge.net>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 March 2010 21:26, Andrew Victor <avictor.za@gmail.com> wrote:
>
> hi,
>
>
> I see in the data-sheet (SAM9261 / SAM9263), the following for the
> UDP_ CSRx registers:
>
> "WARNING: Due to synchronization between MCK and UDPCK, the software
> application must wait for the end of the write
> operation before executing another write by polling the bits which
> must be set/cleared."
>
> //! Clear flags of UDP UDP_CSR register and waits for synchronization
> #define Udp_ep_clr_flag(pInterface, endpoint, flags) { \
>    while (pInterface->UDP_CSR[endpoint] & (flags)) \
>        pInterface->UDP_CSR[endpoint] &= ~(flags); \
>     }
> //! Set flags of UDP UDP_CSR register and waits for synchronization
> #define Udp_ep_set_flag(pInterface, endpoint, flags) { \
>    while ( (pInterface->UDP_CSR[endpoint] & (flags)) != (flags) ) \
>       pInterface->UDP_CSR[endpoint] |= (flags); \
>    }
>
> The at91_udc driver does not seem to do that for its CSR register writes.
> So I was wondering if we implement what the datasheet says, would we
> still need the "fix" above.
>
>
> Regards,
>  Andrew Victor

According to the following post it did not solve the problem:

"There are references to syncronization issues between clock domains
in documentation and source code. These references describe required
delays when setting or clearing bits in CSR until the bit actually
changes and the required delays between writing CSR and reading the
data register. Incorporating the delays suggested in datasheet to code
did not change anything, so I dug deeper."
source:
http://lists.arm.linux.org.uk/lurker/message/20090325.150843.f515c02f.en.html

I did not test this myself, maybe Anti Sullin can give more details.

Regards,

Harro Haan

BTW: same message, but now in plain text.
