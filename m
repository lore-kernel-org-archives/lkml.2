Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab2CISLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:11:44 -0500
Received: from stats.peacock.arvixe.com ([174.122.104.67]:58972 "EHLO
	peacock.arvixe.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753568Ab2CISLm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:11:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=firszt.eu;
	h=Received:Subject:From:To:Cc:Date:In-Reply-To:References:Content-Type:X-Mailer:Content-Transfer-Encoding:Message-ID:Mime-Version;
	b=Hirps1s8bf8L6a71UW+sPhg4sRVPOn37FMlmQWdQSAOmdkkHupGf6VpuJNN4muD/0QqlIzevT29JSBBOzeQ73I6xC3navBWYg0swX747y7bT/c/QW28fTr4Rsf0Hx/dc;
Subject: Re: [Linuxwacom-devel] [PATCH 2/2] HID: wacom: Add reporting of
 wheel for Intuos4 WL
From: Przemo Firszt <przemo@firszt.eu>
To: Jason Gerecke <killertofu@gmail.com>
Cc: jkosina@suse.cz, pinglinux@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxwacom-devel@lists.sourceforge.net
Date: Fri, 09 Mar 2012 18:11:33 +0000
In-Reply-To: <CANRwn3R5fFkujnsPhx++4PSQEwVNnWo_uXa9Zgb6m=SrJPtN0w@mail.gmail.com>
References: <1331299252-23699-1-git-send-email-przemo@firszt.eu>
	 <1331299252-23699-2-git-send-email-przemo@firszt.eu>
	 <CANRwn3R5fFkujnsPhx++4PSQEwVNnWo_uXa9Zgb6m=SrJPtN0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 PLD Linux 
Content-Transfer-Encoding: 8BIT
Message-ID: <1331316698.28974.13.camel@pldmachine>
Mime-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - peacock.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2012-03-09, pią o godzinie 09:37 -0800, Jason Gerecke pisze:
> On Fri, Mar 9, 2012 at 5:20 AM, Przemo Firszt <przemo@firszt.eu> wrote:
> > This patch adds reporting of ABS_WHEEL event. Raported walues are 0..71
> > and are related to absolute location of the finger on the wheel.
> >
> > Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> > ---
> >  drivers/hid/hid-wacom.c |   19 +++++++++++++++++++
> >  1 files changed, 19 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> > index 5c25036..6f65514 100644
> > --- a/drivers/hid/hid-wacom.c
> > +++ b/drivers/hid/hid-wacom.c
> > @@ -36,6 +36,7 @@
> >  struct wacom_data {
> >        __u16 tool;
> >        __u16 butstate;
> > +       __u8 whlstate;
> >        __u8 features;
> >        __u32 id;
> >        __u32 serial;
> > @@ -322,6 +323,16 @@ static void wacom_i4_parse_button_report(struct wacom_data *wdata,
> >                        struct input_dev *input, unsigned char *data)
> >  {
> >        __u16 new_butstate;
> > +       __u8 new_whlstate;
> > +       __u8 sync = 0;
> > +
> > +       new_whlstate = data[1] & 0x7f;
> > +       if (new_whlstate != wdata->whlstate) {
> > +               wdata->whlstate = new_whlstate;
> > +               input_report_key(input, BTN_TOUCH, 1);
> > +               input_report_abs(input, ABS_WHEEL, new_whlstate);
> > +               sync = 1;
> > +       }
> >
> The highest bit of data[1] is a "touched" flag that you'll want to
> check to determine if the wheel is being used. If its unset, you'll
> want to reset ABS_WHEEL and BTN_TOUCH to zero here.
> 
Thanks!
A new patch is on the way...
-- 
Przemo

