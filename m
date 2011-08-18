Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1HRFh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 01:37:28 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:41035 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1HRFh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 01:37:26 -0400
From: JJ Ding <jj_ding@emc.com.tw>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aaron Huang <aaron_huang@emc.com.tw>, Tom Lin <tom_lin@emc.com.tw>,
        Eric Piel <E.A.B.Piel@tudelft.nl>,
        Chase Douglas <chase.douglas@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Alessandro Rubini <rubini@cvml.unipv.it>
Subject: Re: [PATCH 6/6] Input: elantech - add v3 hardware support
In-Reply-To: <CAGS+omDm8RXPLXOnajrJ1hJPS5=mpzaLBybNYY92DMk1j=wByQ@mail.gmail.com>
References: <1313632629-23603-1-git-send-email-jj_ding@emc.com.tw> <1313632629-23603-7-git-send-email-jj_ding@emc.com.tw> <CAGS+omDm8RXPLXOnajrJ1hJPS5=mpzaLBybNYY92DMk1j=wByQ@mail.gmail.com>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Thu, 18 Aug 2011 13:39:47 +0800
Message-ID: <8762lv46sc.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thu, 18 Aug 2011 10:57:57 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Thu, Aug 18, 2011 at 9:57 AM, JJ Ding <jj_ding@emc.com.tw> wrote:
> > v3 hardware's packet format is almost identical to v2 (one/three finger touch),
> > except when sensing two finger touch, the hardware sends 12 bytes of data.
> >
> > Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
> > ---
> >  Documentation/input/elantech.txt |  104 ++++++++++++++++--
> >  drivers/input/mouse/elantech.c   |  218 ++++++++++++++++++++++++++++++++++---
> >  drivers/input/mouse/elantech.h   |   11 ++
> >  3 files changed, 303 insertions(+), 30 deletions(-)
> >
> > +/*
> > + * firmware tells us there's noise.
> > + */
> > +static inline int debounce(unsigned int x, unsigned int y)
> > +{
> > +       return (x == 0xfff) && (y == 0xfff);
> 
> Perhaps you could document this behavior in the elantech.txt.
OK, I will do that.

> >
> > diff --git a/drivers/input/mouse/elantech.h b/drivers/input/mouse/elantech.h
> > index 4b7447e..4f01fc6 100644
> > --- a/drivers/input/mouse/elantech.h
> > +++ b/drivers/input/mouse/elantech.h
> > @@ -16,6 +16,7 @@
> >  /*
> >  * Command values for Synaptics style queries
> >  */
> > +#define ETP_FW_ID_QUERY                        0x00
> 
> One tab too many?
> 
> >  #define ETP_FW_VERSION_QUERY           0x01
> >  #define ETP_CAPABILITIES_QUERY         0x02
> >
> > @@ -24,6 +25,7 @@
> >  */
> >  #define ETP_REGISTER_READ              0x10
> >  #define ETP_REGISTER_WRITE             0x11
> > +#define ETP_REGISTER_READWRITE         0x00
> >
> >  /*
> >  * Hardware version 2 custom PS/2 command value
> > @@ -93,6 +95,13 @@
> >  #define ETP_2FT_YMIN                   (  0 + ETP_2FT_FUZZ)
> >  #define ETP_2FT_YMAX                   (192 - ETP_2FT_FUZZ)
> >
> > +/*
> > + * v3 hardware has 2 kinds of packet types.
> > + */
> > +#define PACKET_UNKNOWN                 0x01
> > +#define PACKET_V3_HEAD                 0x02
> > +#define PACKET_V3_TAIL                 0x03
> > +
> >  struct elantech_data {
> >        unsigned char reg_10;
> >        unsigned char reg_11;
> > @@ -113,6 +122,8 @@ struct elantech_data {
> >        unsigned int single_finger_reports;
> >        unsigned int y_max;
> >        unsigned int y_2ft_max;
> > +       unsigned int prev_x;
> > +       unsigned int prev_y;
> >        unsigned char parity[256];
> >  };
> >
> > --
> > 1.7.4.1
> >
> >
