Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0H1WLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 18:11:53 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:55044 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907Ab0H1WLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 18:11:52 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-08.arcor-online.net AF23A2053B1
Subject: Re: [PATCH] HID: roccat: Fixing race condition on initialization
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-input@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C7952E9.5030608@gmail.com>
References: <1283000268.4789.1.camel@neuromancer>
	 <4C7952E9.5030608@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 Aug 2010 00:11:47 +0200
Message-ID: <1283033507.8037.14.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 28.08.2010, 20:18 +0200 schrieb Jiri Slaby:
> On 08/28/2010 02:57 PM, Stefan Achatz wrote:
> > Fixed raced condition where event occurs before drvdata is set.
> > 
> > Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
> > ---
> >  drivers/hid/hid-roccat-kone.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> > index f776957..cfeab56 100644
> > --- a/drivers/hid/hid-roccat-kone.c
> > +++ b/drivers/hid/hid-roccat-kone.c
> > @@ -966,6 +966,10 @@ static int kone_raw_event(struct hid_device *hdev, struct hid_report *report,
> >  	struct kone_device *kone = hid_get_drvdata(hdev);
> >  	struct kone_mouse_event *event = (struct kone_mouse_event *)data;
> >  
> > +	/* possible race condition on initialization */
> > +	if (!kone)
> > +		return 0;
> 
> This kind of "protection" caused much headache in the tty layer in the
> past. If there is such a problem, please fix the initialization code
> instead.
> 
> What sort of problems you are seeing?
> 
> thanks,

After investigating and now fully understanding the issue I want to draw
back this patch.
The issue was no race condition in the first place, but an erroneous
code I wrote for another mouse. This is a injudicious crossport of a
half baked fix for code that didn't suffer from the problem because the
next 3 lines already do the right thing for this case.
Sorry.

