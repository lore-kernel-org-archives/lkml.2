Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1JKQVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:21:36 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37037 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752818Ab1JKQVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:21:35 -0400
X-Sasl-enc: WlztXur4rqam+7NHPxkENUG6ubg1vPG6YoZ66sSh5jBO 1318350094
Date: Tue, 11 Oct 2011 10:20:23 -0600
From: Greg KH <greg@kroah.com>
To: Pelle Windestam <pelle@windestam.se>
Cc: Pelle Windestam <iceaway@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: panel: Fixed checkpatch warning about
 simple_strtoul()
Message-ID: <20111011162023.GA16261@kroah.com>
References: <1314728964-20863-1-git-send-email-iceaway@gmail.com>
 <CAOdCkm2mtU8v4YrU2-r2aRJOFKruk0mWUV9T67gheykM=74DfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOdCkm2mtU8v4YrU2-r2aRJOFKruk0mWUV9T67gheykM=74DfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 12:11:31PM +0200, Pelle Windestam wrote:
> On Tue, Aug 30, 2011 at 8:29 PM, Pelle Windestam <iceaway@gmail.com> wrote:
> > Fixed the checkpatch warning about sing simple_strtoul instead of
> > kstrtoul() in panel.c.
> >
> > Signed-off-by: Pelle Windestam <iceaway@gmail.com>
> > ---
> >  drivers/staging/panel/panel.c |   10 ++++------
> >  1 files changed, 4 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
> > index b303b7e..4683d5f 100644
> > --- a/drivers/staging/panel/panel.c
> > +++ b/drivers/staging/panel/panel.c
> > @@ -1179,16 +1179,14 @@ static inline int handle_lcd_special_code(void)
> >                        break;
> >
> >                while (*esc) {
> > -                       char *endp;
> > -
> >                        if (*esc == 'x') {
> >                                esc++;
> > -                               lcd_addr_x = simple_strtoul(esc, &endp, 10);
> > -                               esc = endp;
> > +                               if (kstrtoul(esc, 10, &lcd_addr_x) < 0)
> > +                                       break;
> >                        } else if (*esc == 'y') {
> >                                esc++;
> > -                               lcd_addr_y = simple_strtoul(esc, &endp, 10);
> > -                               esc = endp;
> > +                               if (kstrtoul(esc, 10, &lcd_addr_y) < 0)
> > +                                       break;
> >                        } else
> >                                break;
> >                }
> > --
> > 1.7.3.4
> >
> >
> 
> Was there any reason for not accepting this patch?

I don't recall ever seeing it before, care to resend it against the
latest linux-next tree so I can apply it?

thanks,

greg k-h
