Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0EQQXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:23:08 -0400
Received: from mail-gx0-f217.google.com ([209.85.217.217]:61469 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0EQQXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AMZKihNuONSuhumy6rj4n+KUNGRR4+qhBbwMOySMODDqBswqN4IqTfPYpXPGSTrE+L
         eWpWVrZI4zyCDe6SyQuUp6vavIGI61ClJQu77L5GlNaM8eLiC2gWnUaajlVFTa5wRN6P
         byHdG6reKoJQOUsuAM+e4dfpb9TpKVr9cEl/s=
MIME-Version: 1.0
In-Reply-To: <20100517143319.GC5257@opensource.wolfsonmicro.com>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
	 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
	 <20100517031613.GA3130@opensource.wolfsonmicro.com>
	 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
	 <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
	 <20100517143319.GC5257@opensource.wolfsonmicro.com>
Date: Mon, 17 May 2010 21:53:03 +0530
Message-ID: <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
Subject: Re: Fwd: [linux-pm] Power Domain Framework
From: Sundar <sunder.svit@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Deepak Sikri <deepak.sikri79@gmail.com>, viresh.kumar@st.com,
       rajeev-dlh.kumar@st.com, armando.visconti@st.com,
       linux-kernel@vger.kernel.org, vipin.kumar@st.com, shiraz.hashim@st.com,
       linux-pm@lists.linux-foundation.org, linus.walleij@stericsson.com,
       STEricsson_nomadik_linux@list.st.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 8:03 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, May 17, 2010 at 07:03:57PM +0530, Sundar wrote:
>
> There's two problems I see.  One is expressing the operating modes in a
> way that is suitably abstract and will work for more than one chip.
Okay.

> other is that as soon as the regulator driver has to know something
> about the consumers you're running into trouble.
>
> The major goal of the regulator API is to allow us to match up consumer
> drivers with regulator drivers without having any device specific tie
> between the two.  Pushing things that need such tie in through the API
> breaks that.
>
Aren't machine constraints, setting maximum current limit based on total loads
similar to primitive tie ups between devices and regulator driver?

> Are you sure about these statements?  Bear in mind that with a regulator
> on a separate device there is no direct way for the regulator to know
> anything about what the device it is supplying is doing, and not only
> are latency requirements for mode changes are very tight but there may
> not be any software running when the mode changes which is in a position
> to relay information to the regulator.  The trend with regulators
> appears to be rather more towards removal of user visible control of the
> internal operating modes of the regulator itself with the device
> reconfiguring itself based on the ability to achieve good regulation at
> a given load point.  This gives good responsivness and efficiency over
> the full range of loads.
I am still confused about the knowledge of regulator about its consumer. How
I see is, with the added controls, it is still devoid of any
information about its
clients. All that a regulator still would know is if at all there are
any clients which
require it at full load. I think the function *set_optimal_load is
very similar to a OPP
control mechanism. Instead of summing up load currents, now there are
constraints.
Probably you may look at the patch set at the end of this mail and comment.

> have various power modes doesn't impact on the regulator except in that
> it may be able to get some information about the range of currents being
> supplied.  The converse also applies - the consumer doesn't really need
> to know anything about what the regulator is up to internally.
IMO, this leads to a more decisive control over what state the
regulator *can* be in;
without affecting any child clients.

> The big difference is that the on-SoC power domain configuration does
> frequently rely on an abstraction other than the simple voltage plus
> load one that the regulator API represents, as I said this frequently
which is what I see as that can be bridged down.

> includes a strong tie in with information about the device clocking.
> Typically changing the operating mode will change or limit the clock
> rates in use in various parts of the device.
cannot these be handled with existing/new notifiers in place?

Regards,
Sundar
P.S : Let me post out the patch set following on.
