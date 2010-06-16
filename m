Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0FPGin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:38:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41333 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab0FPGil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:38:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FrYUs15sdTT5uBhzaGqMS7wiI/gfRQ4lwUx481t6t+ZTwZQRdvnWC6+aU2SZq0cfHE
         qzYExnYpXWN10eLQ9Euaj68CuEmgDWcIJyPGHUFZkxIS7zKl0eOPMJ0PqlSxu5oNUZ6u
         7BI/wHt/0V0HAQ0Y8hT2S22h/Tas/Ww9r7Zjg=
MIME-Version: 1.0
In-Reply-To: <4C184C1C.4000204@st.com>
References: <1276270031-1607-1-git-send-email-linus.walleij@stericsson.com>
	<4C15C60E.6080404@st.com>
	<AANLkTim9n-p-Pw6FWvzQMBiAuB3h9ILq1Ya6XWk_0l-c@mail.gmail.com>
	<4C170EE2.4010706@st.com>
	<CEE6BB42CAD6E947908279175AF8470A025E5AE1ED@EXDCVYMBSTM006.EQ1STM.local>
	<4C184C1C.4000204@st.com>
Date: Wed, 16 Jun 2010 08:38:38 +0200
Message-ID: <AANLkTinZgUzXy9wH760foYDqbr5gvHO07LkiCco_q8Wj@mail.gmail.com>
Subject: Re: [PATCH 06/13] DMAENGINE: driver for the ARM PL080/PL081 
	PrimeCells
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Viresh KUMAR <viresh.kumar@st.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "yuanyabin1978@sina.com" <yuanyabin1978@sina.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Pearse <peter.pearse@arm.com>, Ben Dooks <ben-linux@fluff.org>,
       Kukjin Kim <kgene.kim@samsung.com>, Alessandro Rubini <rubini@unipv.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Viresh]

> In the same way, how other peripheral related data is passed to DMA driver,
> (like request lines), we can also pass configuration and control information.

Yep.

> In SPEAr6xx, Memory is accessible from Master1
> only but in SPEAr3xx only from Master 2, similar is the pattern with few
> peripherals also and so i need control over DMA channel configuration.

Oh I had no clue that you could set up your masters like that!
Anyway, I'll attempt to hack in some platform config for how
the AHB masters are assigned, but you'll likely have to patch it
to work with SPEAr in the end.

>> Currently only done dynamically with DMA as the master for
>> Mem2mem, mem2per and per2mem. Mastering from the peripherals
>> is not supported. Do you have advanced features like that?
>
> We have JPEG controller, which acts as a flow controller for JPEG to
> mem transfer. (Synopsys JPEG Controller).

OK that's special..

>> Anyway it can be passed in from platform data easily.
>
> But platform data will be passed one time only and we will not be able to
> do it while transferring data at run time.

Usually there is a very fixed use for each virtual DMA channel (which
have a platform config each), i.e. usually there is only one or two
flow controls per virtual channel. So in this case I guess that
Synopsys JPEG has a virtual channel that always is JPEG->mem with
JPEG as master, so it can actually be in fix platform data?

Anyway, we can probably extended either the way we did for PrimeCells
or in some generic way by adding config commands to the DMAengine,
so I see no road blocker.

Yours,
Linus Walleij
