Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1DMPcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:32:41 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:35154 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab1DMPck convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:32:40 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH] Clean console safely
Date: Wed, 13 Apr 2011 17:32:37 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-gentoo-r1; KDE/4.4.5; x86_64; ; )
Cc: Petr =?utf-8?q?P=C3=ADsa=C5=99?= <ppisar@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
References: <1302705651.2768.21.camel@localhost> <1302706473-16519-1-git-send-email-ppisar@redhat.com> <m38vvew577.fsf@pullcord.laptop.org>
In-Reply-To: <m38vvew577.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104131732.38829.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 13 April 2011, 17:18:04 Chris Ball wrote:
> On Wed, Apr 13 2011, Petr Písař wrote:
> > Traditional \E[2J sequence erases console display but scroll-back
> > buffer and underlying device (frame) buffer keep data that can be
> > accessed by scrolling console back.
> > 
> > This patch introduce new \E[J parameter 3 that allows to scramble
> > scroll-back buffer explicitly. Session locking programs (screen,
> > vlock) can use it to prevent attacker to browse locked console
> > history.
> > 
> > Signed-off-by: Petr Písař <ppisar@redhat.com>
> > ---
> > 
> >  drivers/tty/vt/vt.c |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> > index 4bea1ef..fe96a1f 100644
> > --- a/drivers/tty/vt/vt.c
> > +++ b/drivers/tty/vt/vt.c
> > @@ -1197,6 +1197,12 @@ static void csi_J(struct vc_data *vc, int vpar)
> > 
> >  					      vc->vc_x + 1);
> >  			
> >  			}
> >  			break;
> > 
> > +		case 3: /* erase scroll-back buffer (and whole display) */
> > +			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
> > +				    vc->vc_screenbuf_size >> 1);
> > +			set_origin(vc);
> > +			if (CON_IS_VISIBLE(vc))
> > +				update_screen(vc);
> > 
> >  		case 2: /* erase whole display */
> >  		
> >  			count = vc->vc_cols * vc->vc_rows;
> >  			start = (unsigned short *)vc->vc_origin;
> 
> Nitpick: the cases were ordered before -- 3 should go after 2.

Not if the fall-through is intended.

Alexander
