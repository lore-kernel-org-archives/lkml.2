Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab2IZG4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 02:56:45 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50754 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2IZG4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 02:56:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=k=WPh4uPor=K+J752dR-pqZbieytkx-G7JGt+6LE_qSw@mail.gmail.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348575190-11761-3-git-send-email-andriy.shevchenko@linux.intel.com>
	<CAOh2x=kEDfY_DaBdbeY+CREiRJDH5yeNLUUuSpGTZcdWtZEd7g@mail.gmail.com>
	<1348642068.13371.135.camel@smile>
	<CAOh2x=k=WPh4uPor=K+J752dR-pqZbieytkx-G7JGt+6LE_qSw@mail.gmail.com>
Date: Wed, 26 Sep 2012 09:56:43 +0300
Message-ID: <CAHp75VfRWpkTPq2S=oTuWK+DhWoT-MDZd_4nnZW0GkEBSUM=zA@mail.gmail.com>
Subject: Re: [PATCHv1 2/6] dmaengine: dw_dmac: add driver for Atmel AT32
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 9:51 AM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Wed, Sep 26, 2012 at 12:17 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>
>> This separate driver makes no sense in case it is built properly without
>> CLK framework. Let me check this and leave comments at patch 1/6.
>
> Following is the commit that introduced this change :)
Thanks for pointing to it

>
> commit 93abe8e4b13ae9a0428ce940a8a03ac72a7626f1
> Author: Viresh Kumar <viresh.kumar@st.com>
> Date:   Mon Jul 30 14:39:27 2012 -0700
A-ha, this explains: Heikki's patches are stamped as follows

commit 7c33a7ec5f1f68c1ab06eee7ff7118a7b62db5da
Author: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date:   Mon May 7 12:31:29 2012 +0300

>
>     clk: add non CONFIG_HAVE_CLK routines
>
>     Many drivers are shared between architectures that may or may not have
>     HAVE_CLK selected for them.  To remove compilation errors for them we
>     enclose clk_*() calls in these drivers within #ifdef CONFIG_HAVE_CLK,
>     #endif.
>
>     This patch removes the need of these CONFIG_HAVE_CLK statements, by
>     introducing dummy routines when HAVE_CLK is not selected by platforms.
>     So, definition of these routines will always be available.  These calls
>     will return error for platforms that don't select HAVE_CLK.
>
>     Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
>     Cc: Wolfram Sang <w.sang@pengutronix.de>
>     Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Cc: Jeff Garzik <jgarzik@redhat.com>
>     Cc: Andrew Lunn <andrew@lunn.ch>
>     Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
>     Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
>     Cc: Russell King <rmk@arm.linux.org.uk>
>     Cc: Mike Turquette <mturquette@linaro.org>
>     Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
>     Cc: viresh kumar <viresh.linux@gmail.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
