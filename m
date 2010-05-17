Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0EQNeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:34:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56399 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0EQNd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ikHp7v+TtjmSWi9oIZ1pMKls92phgZg3DTWQrPUZfgFkwU0UYHTatNDnT8vJhotYSr
         lbFF6ONF/AKv4by88584P7kKNnYsX+HMzJ0aEzG2FXcUs+HubO3hIH5/+tQTxJZrG9Ds
         JsbauYnd9UQ1XKNdDE/cTlLmIhckl3FyuE0zs=
MIME-Version: 1.0
In-Reply-To: <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
References: <AANLkTinZU1D1rMOBQDi47tRhXrOXwduQIdni7bCXdce0@mail.gmail.com>
	 <20100510140527.GG5199@sirena.org.uk>
	 <AANLkTikyqnKDNz7FIUvLDAvBReHskHvRCrEz2qBBqseH@mail.gmail.com>
	 <20100517031613.GA3130@opensource.wolfsonmicro.com>
	 <AANLkTimDdBCnRFMDiUkuNKanOzuPNwCpfRv9Gsi03Lsy@mail.gmail.com>
Date: Mon, 17 May 2010 19:03:57 +0530
Message-ID: <AANLkTinZRhUpFTOOUCdH5dEl3QaXn10USL_hPPQX8cie@mail.gmail.com>
Subject: Fwd: [linux-pm] Power Domain Framework
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

Hi,

On Mon, May 17, 2010 at 8:46 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sun, May 16, 2010 at 04:43:52PM +0530, Sundar wrote:
>
> Please don't top post, it breaks the thread of discussion.
Sorry.

> I'm really not convinced that this is a good idea.  Generally I suspect
> the implementations of these concepts that I've seen would introduce
> layering violations if done via the regulator API - from what I've seen
> the power domains can end up knowing rather more about the things that
> are being powered than is healthy for the regulator API and...

I am sorry but I do not understand how this can violate the framework APIs.
Even know, a regulator knows about its machine constraints, valid features
w.r.t operating modes, DRMS, load currents etc. What additional information
the regulator would be associated with would be operating points, constraints
w.r.t peripherals etc.

> I do think it's likely that you'll want something that looks like the
> regulator API at the edges, but that a separate implementation that
> avoids having to shoehorn through the abstractions of the regulator API
> for the on-chip work seems much more sensible (and is what OMAP and SH

True. But a separate implementation is not needed because the current
framework already provides me support for a majority of features. Features like
OPP control, power states which are usually associated with SoC power domains
are available on modem regulators. When such features will eventually creep in
the regular framework, then why distinguish between on-SoC power sources
and on-board power sources..

> are already doing).  This is fairly similar to the relationship between
> the clock and regulator APIs - they look a lot alike, especially from a
> user point of view, but they are separate because there are enough
> differences in what they are trying to represent to make it sensible to
> keep them apart.

Agreed. But if I compare a SoC power domain and a regulator power domain, I
dont see differences to keep them apart. Please correct me if I am wrong.

> However, if you have patches it's probably easier to talk about those
> than architecture astronauting; perhaps your implementation avoids my
> concerns.
>
Okay. I will surely send them out.

Regards,
Sundar
