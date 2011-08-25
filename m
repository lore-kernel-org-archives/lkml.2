Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab1HYBGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 21:06:40 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:5560 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab1HYBGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 21:06:37 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        =?utf-8?Q?=C3=89r?= =?utf-8?Q?ic?= Piel <E.A.B.Piel@tudelft.nl>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH v2 7/7] Input: elantech - add v3 hardware support
In-Reply-To: <20110824143520.GB23868@thinkpad-t410>
References: <1314164686-866-1-git-send-email-jj_ding@emc.com.tw> <1314164686-866-8-git-send-email-jj_ding@emc.com.tw> <20110824143520.GB23868@thinkpad-t410>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 25 Aug 2011 09:09:02 +0800
Message-ID: <87mxeynvpt.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

Thank you. You are right.
I think I somehow tested the worng touchpad for this patch.

jj

On Wed, 24 Aug 2011 09:35:20 -0500, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Wed, Aug 24, 2011 at 01:44:46PM +0800, JJ Ding wrote:
> > @@ -403,11 +503,39 @@ static int elantech_packet_check_v2(struct psmouse *psmouse)
> >  }
> >  
> >  /*
> > + * We check the constant bits to determine what packet type we get,
> > + * so packet checking is mandatory for v3 hardware.
> > + */
> > +static int elantech_packet_check_v3(struct psmouse *psmouse)
> > +{
> > +	unsigned char *packet = psmouse->packet;
> > +
> > +	if ((packet[0] & 0x0c) == 0x04 &&
> > +	    (packet[3] & 0xcf) == 0x02)
> > +		return PACKET_V3_HEAD;
> > +
> > +	if ((packet[0] & 0x0c) == 0x0c &&
> > +	    (packet[3] & 0xce) == 0x0c)
> > +		return PACKET_V3_TAIL;
> > +
> > +	if (packet[0] == 0xc4 &&
> > +	    packet[1] == 0xff &&
> > +	    packet[2] == 0xff &&
> > +	    packet[3] == 0x02 &&
> > +	    packet[4] == 0xff &&
> > +	    packet[5] == 0xff)
> > +		return PACKET_DEBOUNCE;
> > +
> > +	return PACKET_UNKNOWN;
> > +}
> 
> This will never return PACKET_DEBOUNCE, because those packets will have
> already matched the conditions for PACKET_V3_HEAD. That condition needs
> to be moved to the top of the function.
> 
> Seth
