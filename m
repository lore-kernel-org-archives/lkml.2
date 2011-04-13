Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab1DNAYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 20:24:09 -0400
Received: from wdscspam2.wdc.com ([129.253.55.43]:26756 "EHLO
	wdscspam2.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1DNAYH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 20:24:07 -0400
X-Greylist: delayed 1164 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Apr 2011 20:24:07 EDT
X-IronPort-AV: E=Sophos;i="4.64,207,1301900400"; 
   d="scan'208";a="176973964"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Clean console safely
Date: Wed, 13 Apr 2011 16:55:01 -0700
Message-ID: <25B374CC0D9DFB4698BB331F82CD0CF2E3EC04@wdscexbe08.sc.wdc.com>
In-Reply-To: <m34o62w3yn.fsf@pullcord.laptop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Clean console safely
Thread-Index: Acv58SmhyIJ9bYleQ36Uvz/UO2SSrwAQ/onw
References: <1302705651.2768.21.camel@localhost><1302706473-16519-1-git-send-email-ppisar@redhat.com><m38vvew577.fsf@pullcord.laptop.org><20110413152829.GB2993@dhcp-0-146.brq.redhat.com> <m34o62w3yn.fsf@pullcord.laptop.org>
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Artem Bityutskiy" <dedekind1@gmail.com>,
        "Chris Ball" <cjb@laptop.org>, "Greg Kroah-Hartman" <gregkh@suse.de>
X-OriginalArrivalTime: 13 Apr 2011 23:55:01.0551 (UTC) FILETIME=[33DD4BF0:01CBFA36]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Chris Ball
> Sent: Wednesday, April 13, 2011 8:45 AM
> To: Greg Kroah-Hartman
> Cc: Alan Cox; linux-kernel@vger.kernel.org; Artem Bityutskiy
> Subject: Re: [PATCH] Clean console safely
> 
> Hi,
> 
> On Wed, Apr 13 2011, Petr Pisar wrote:
> > On Wed, Apr 13, 2011 at 11:18:04AM -0400, Chris Ball wrote:
> >> 
> >> On Wed, Apr 13 2011, Petr Písaø wrote:
> >> > Traditional \E[2J sequence erases console display but scroll-back
> >> > buffer and underlying device (frame) buffer keep data that can be
> >> > accessed by scrolling console back.
> >> >
> >> > This patch introduce new \E[J parameter 3 that allows to scramble
> >> > scroll-back buffer explicitly. Session locking programs (screen,
> >> > vlock) can use it to prevent attacker to browse locked console
> >> > history.
> >> >
> >> > Signed-off-by: Petr Písaø <ppisar@redhat.com>
> >> > ---
> >> >  drivers/tty/vt/vt.c |    6 ++++++
> >> >  1 files changed, 6 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> >> > index 4bea1ef..fe96a1f 100644
> >> > --- a/drivers/tty/vt/vt.c
> >> > +++ b/drivers/tty/vt/vt.c
> >> > @@ -1197,6 +1197,12 @@ static void csi_J(struct vc_data 
> *vc, int vpar)
> >> >  					      vc->vc_x + 1);
> >> >  			}
> >> >  			break;
> >> > +		case 3: /* erase scroll-back buffer 
> (and whole display) */
> >> > +			scr_memsetw(vc->vc_screenbuf, 
> vc->vc_video_erase_char,
> >> > +				    vc->vc_screenbuf_size >> 1);
> >> > +			set_origin(vc);
> >> > +			if (CON_IS_VISIBLE(vc))
> >> > +				update_screen(vc);
> >> >  		case 2: /* erase whole display */
> >> >  			count = vc->vc_cols * vc->vc_rows;
> >> >  			start = (unsigned short *)vc->vc_origin;
> >> 
> >> Nitpick: the cases were ordered before -- 3 should go after 2.
> >> 
> > This is on purpose to continue with code for case 2 as it 
> prepares variables
> > for cleaning visible part of display after the switch block.
> 
> Oops, sorry; I saw an imaginary break statement there.

Shouldn't there be a "/* fall through */", or similar, comment,
or all of the existing ones in the kernel extraneous?  Personally,
I prefer to see clearly that the missing "break" is intentional.

> 
> - Chris.
> -- 
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
