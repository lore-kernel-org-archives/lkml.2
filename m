Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab2JVIi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:38:29 -0400
Received: from zmc.proxad.net ([212.27.53.206]:37403 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab2JVIi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:38:27 -0400
From: Florian Fainelli <ffainelli@freebox.fr>
To: Kees Cook <keescook@chromium.org>
Cc: cbouatmailru@gmail.com, ccross@android.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        stable@vger.kernel.org
Subject: Re: [PATCH] pstore/ram: fix undefined usage of rounddown_pow_of_two.
Date: Mon, 22 Oct 2012 10:37:10 +0200
Message-ID: <1807287.lsQvlHRIOP@flexo>
Organization: Freebox
User-Agent: KMail/4.8.5 (Linux/3.2.0-24-generic; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAGXu5j+sNV2XCBCA4HQOXyS66MVzzcJDottFdh9hDW5LcD45HA@mail.gmail.com>
References: <1350647942-5260-1-git-send-email-ffainelli@freebox.fr> <CAGXu5j+sNV2XCBCA4HQOXyS66MVzzcJDottFdh9hDW5LcD45HA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 October 2012 09:03:12 Kees Cook wrote:
> On Fri, Oct 19, 2012 at 4:59 AM, Florian Fainelli <ffainelli@freebox.fr> wrote:
> > From: Maxime Bizon <mbizon@freebox.fr>
> >
> > record_size / console_size / ftrace_size can be 0 (this is how you
> > disable the feature), but rounddown_pow_of_two(0) is undefined. This problem
> > has been present since commit 1894a253 (ramoops: Move to fs/pstore/ram.c).
> >
> > Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> > Signed-off-by: Florian Fainelli <ffainelli@freebox.fr>
> > CC: stable@vger.kernel.org
> > ---
> >  fs/pstore/ram.c |   12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> > index 1a4f6da..0c2ae26 100644
> > --- a/fs/pstore/ram.c
> > +++ b/fs/pstore/ram.c
> > @@ -374,10 +374,14 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
> >                 goto fail_out;
> >         }
> >
> > -       pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> > -       pdata->record_size = rounddown_pow_of_two(pdata->record_size);
> > -       pdata->console_size = rounddown_pow_of_two(pdata->console_size);
> > -       pdata->ftrace_size = rounddown_pow_of_two(pdata->ftrace_size);
> > +       if (pdata->mem_size)
> > +               pdata->mem_size = rounddown_pow_of_two(pdata->mem_size);
> 
> Nice catch!
> 
> Instead of the == 0 check, what about using !is_power_of_2(size) ?

That would work equally well, I will resubmit with this then.
--
Florian
