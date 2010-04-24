Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab0DXOIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 10:08:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65010 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab0DXOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 10:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:message-id;
        b=BEWeviPiNcgbh7+5/tGafh0Gq6by5eQE0GKyqnuYwLOLMSbm8/8Uj45En93TAIrOyV
         v/EV+9512nf5bA8iYmHOrSKo77MqprpRGpR25WtN7p6bB5PCK+KFxNk5/8c3rxdNe1MR
         DHte1gtDXpBBYwA2yN4y0guAspKzaGxu6xblg=
From: Farid Hammane <farid.hammane@gmail.com>
To: khali@linux-fr.org, w.sang@pengutronix.de, ben-linux@fluff.org,
       Enrik.Berkhan@ge.com, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] i2c-algo-pca: fix coding style issues in i2c-algo-pca.c
Date: Sat, 24 Apr 2010 16:07:33 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.30-2-686; KDE/4.3.4; i686; ; )
References: <1271973715-18331-1-git-send-email-farid.hammane@gmail.com> <20100423113326.3691bdd6@hyperion.delvare>
In-Reply-To: <20100423113326.3691bdd6@hyperion.delvare>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004241607.33489.farid.hammane@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Friday 23 April 2010 11:33:26 you wrote:
> Hi Farid, Wolfram,
> 
> On Fri, 23 Apr 2010 00:01:55 +0200, Farid Hammane wrote:
> > This patch fixes coding style issues found by checkpatch.pl.
> > i2c-algo-pca.c has been built successfully after applying this patch.
> >
> > Signed-off-by: Farid Hammane <farid.hammane@gmail.com>
> > ---
> >  drivers/i2c/algos/i2c-algo-pca.c |   36
> > ++++++++++++++++++------------------ 1 files changed, 18 insertions(+),
> > 18 deletions(-)
> >
> > diff --git a/drivers/i2c/algos/i2c-algo-pca.c
> > b/drivers/i2c/algos/i2c-algo-pca.c index dcdaf8e..ca817f8 100644
> > --- a/drivers/i2c/algos/i2c-algo-pca.c
> > +++ b/drivers/i2c/algos/i2c-algo-pca.c
> > @@ -37,15 +37,15 @@
> >
> >  static int i2c_debug;
> >
> > -#define pca_outw(adap, reg, val) adap->write_byte(adap->data, reg, val)
> > -#define pca_inw(adap, reg) adap->read_byte(adap->data, reg)
> > +#define pca_outw(adap, reg, val) (adap->write_byte(adap->data, reg,
> > val)) +#define pca_inw(adap, reg) (adap->read_byte(adap->data, reg))
> 
> I'm confused by these changes. For one thing, macros which are
> shortcuts for function calls normally don't need surrounding
> parentheses. If checkpatch.pl complains about that, I would call it a
> false positive, unless someone can prove me wrong with a real-world
> case where these surrounding parentheses help.
> 
> For another, macro _parameters_ normally need parentheses for each
> non-trivial use. I would thus expect the following to be correct:
> 
> #define pca_outw(adap, reg, val) (adap)->write_byte((adap)->data, reg, val)
> #define pca_inw(adap, reg) (adap)->read_byte((adap)->data, reg)
> 
> Or is it just me?

You are right ! This will be deleted from the patch.

> 
> >  #define pca_status(adap) pca_inw(adap, I2C_PCA_STA)
> > -#define pca_clock(adap) adap->i2c_clock
> > +#define pca_clock(adap) (adap->i2c_clock)
> >  #define pca_set_con(adap, val) pca_outw(adap, I2C_PCA_CON, val)
> >  #define pca_get_con(adap) pca_inw(adap, I2C_PCA_CON)
> > -#define pca_wait(adap) adap->wait_for_completion(adap->data)
> > -#define pca_reset(adap) adap->reset_chip(adap->data)
> > +#define pca_wait(adap) (adap->wait_for_completion(adap->data))
> > +#define pca_reset(adap) (adap->reset_chip(adap->data))
> 
> Same here...
> 
> I'm fine with all other changes. But checkpatch.pl spouts 2 more errors
> to me, which we've discussed before. I'm curious why you didn't fix
> them? Just replace each block of 8 spaces with one tab.

I thought you expected just one tab and spaces. You said :
"Better use tab + spaces and align on the opening parenthesis. What
checkpatch.pl complains about here isn't the alignment, it's the use of
more than 8 consecutive spaces."
I understood here : "don't care about this warning !"

So, I'll fix it.

> 
> ERROR: code indent should use tabs where possible
> #181: FILE: i2c/algos/i2c-algo-pca.c:181:
> +                    struct i2c_msg *msgs,$
> 
> ERROR: code indent should use tabs where possible
> #182: FILE: i2c/algos/i2c-algo-pca.c:182:
> +                    int num)$
> 

Thanks for you comments and for sharing your knowledge !

A patch V3 will be sent,

Regards,
Farid,
