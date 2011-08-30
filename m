Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1H3VHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 17:07:20 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:42197 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756730Ab1H3VHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 17:07:17 -0400
Date: Tue, 30 Aug 2011 14:07:13 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] input: fix misc/twl6040-vibra.c warning
Message-Id: <20110830140713.637b60f1.rdunlap@xenotime.net>
In-Reply-To: <20110830065931.GA5791@core.coreip.homeip.net>
References: <20110829125017.9337299c.rdunlap@xenotime.net>
	<20110830065931.GA5791@core.coreip.homeip.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 23:59:31 -0700 Dmitry Torokhov wrote:

> Hi Randy,
> 
> On Mon, Aug 29, 2011 at 12:50:17PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@xenotime.net>
> > 
> > Fix warning from Geert's build summary emails by changing "if" to
> > "ifdef".  Also handle the case of CONFIG_PM_SLEEP not enabled.
> > 
> > drivers/input/misc/twl6040-vibra.c:231:5: warning: "CONFIG_PM_SLEEP" is not defined
> > 
> > Builds cleanly with CONFIG_PM_SLEEP enabled or disabled.
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> > ---
> >  drivers/input/misc/twl6040-vibra.c |   11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> > --- linux-next-20110829.orig/drivers/input/misc/twl6040-vibra.c
> > +++ linux-next-20110829/drivers/input/misc/twl6040-vibra.c
> > @@ -228,7 +228,7 @@ static void twl6040_vibra_close(struct i
> >  	mutex_unlock(&info->mutex);
> >  }
> >  
> > -#if CONFIG_PM_SLEEP
> > +#ifdef CONFIG_PM_SLEEP
> 
> This is actually the only change that is needed. In case when
> CONFIG_PM_SLEEP is not defined SIMPLE_DEV_PM_OPS() produces empty
> 'struct dev_pm_ops' so no additional #ifdef-ing is needed.

Ah, I see.  Thanks for the info.
Do I need to resend the patch?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
