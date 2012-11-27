Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377Ab2K0IkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:40:15 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39639 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab2K0IkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:40:13 -0500
Date: Tue, 27 Nov 2012 08:40:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] mfd: stmpe: Update DT support in stmpe driver
Message-ID: <20121127084007.GA7897@gmail.com>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
 <7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org>
 <20121123094132.EFCB73E07BE@localhost>
 <CAKohpomAM2pw9kgB6khtHzQ2WCXKZ9_pi1_sOH2dQToVS8ep4w@mail.gmail.com>
 <20121126184015.784993E091F@localhost>
 <CAKohpo=dHz-fJRdwovOWesAZJwibgrNk-+2t--JK+T_sBsu9Tw@mail.gmail.com>
 <CAKohpomOxfLhpZqpk3aymdNa7UAGRcex7d+N5srkFDnrhtULTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKohpomOxfLhpZqpk3aymdNa7UAGRcex7d+N5srkFDnrhtULTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2012, Viresh Kumar wrote:

> On 27 November 2012 08:10, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > On 27 November 2012 00:10, Grant Likely <grant.likely@secretlab.ca> wrote:
> >> It would actually be good to ask the interrupt controller driver what
> >> kind of interrupt signal it expects for a given interrupt line. That
> >> should also solve the problem and I think it would be more useful to
> >> other devices. Can you investigate whether or not
> >> irqd_get_trigger_type() returns the information you need?
> >
> > That's a pretty cool function to use. :)
> >
> > Will check it out :)
> 
> I was thinking about this logic in my earlier mail, don't know what stopped me
> from thinking it is wrong. :(
> 
> Problem is with invert polarity, which the interrupt controller is not aware of.
> For example, suppose interrupt controller needs Rising edge interrupt, but
> the board has inverted the line between stmpe and IC. So, we will get
> Rising high from the routine you mentioned, but we need to generate
> opposite of that to make it rising high.

Surely that would be a hardware design error/quirk?

Can you give an example where this has happened?

> And so interrupt polarity field is still required.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
