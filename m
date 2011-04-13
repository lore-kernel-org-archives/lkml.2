Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab1DMPkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:40:04 -0400
Received: from void.printf.net ([89.145.121.20]:43127 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756786Ab1DMPkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:40:03 -0400
From: Chris Ball <cjb@laptop.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH] Clean console safely
References: <1302705651.2768.21.camel@localhost>
	<1302706473-16519-1-git-send-email-ppisar@redhat.com>
	<m38vvew577.fsf@pullcord.laptop.org>
	<20110413152829.GB2993@dhcp-0-146.brq.redhat.com>
Date: Wed, 13 Apr 2011 11:44:48 -0400
In-Reply-To: <20110413152829.GB2993@dhcp-0-146.brq.redhat.com> (Petr Pisar's
	message of "Wed, 13 Apr 2011 17:28:29 +0200")
Message-ID: <m34o62w3yn.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 13 2011, Petr Pisar wrote:
> On Wed, Apr 13, 2011 at 11:18:04AM -0400, Chris Ball wrote:
>> 
>> On Wed, Apr 13 2011, Petr Písař wrote:
>> > Traditional \E[2J sequence erases console display but scroll-back
>> > buffer and underlying device (frame) buffer keep data that can be
>> > accessed by scrolling console back.
>> >
>> > This patch introduce new \E[J parameter 3 that allows to scramble
>> > scroll-back buffer explicitly. Session locking programs (screen,
>> > vlock) can use it to prevent attacker to browse locked console
>> > history.
>> >
>> > Signed-off-by: Petr Písař <ppisar@redhat.com>
>> > ---
>> >  drivers/tty/vt/vt.c |    6 ++++++
>> >  1 files changed, 6 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
>> > index 4bea1ef..fe96a1f 100644
>> > --- a/drivers/tty/vt/vt.c
>> > +++ b/drivers/tty/vt/vt.c
>> > @@ -1197,6 +1197,12 @@ static void csi_J(struct vc_data *vc, int vpar)
>> >  					      vc->vc_x + 1);
>> >  			}
>> >  			break;
>> > +		case 3: /* erase scroll-back buffer (and whole display) */
>> > +			scr_memsetw(vc->vc_screenbuf, vc->vc_video_erase_char,
>> > +				    vc->vc_screenbuf_size >> 1);
>> > +			set_origin(vc);
>> > +			if (CON_IS_VISIBLE(vc))
>> > +				update_screen(vc);
>> >  		case 2: /* erase whole display */
>> >  			count = vc->vc_cols * vc->vc_rows;
>> >  			start = (unsigned short *)vc->vc_origin;
>> 
>> Nitpick: the cases were ordered before -- 3 should go after 2.
>> 
> This is on purpose to continue with code for case 2 as it prepares variables
> for cleaning visible part of display after the switch block.

Oops, sorry; I saw an imaginary break statement there.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
