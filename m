Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab0CVIyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 04:54:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:43699 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0CVIyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 04:54:19 -0400
Date: Mon, 22 Mar 2010 09:54:12 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 1/6] hid: new driver for PicoLCD device
In-Reply-To: <20100321173737.5fcf3580@neptune.home>
Message-ID: <alpine.LNX.2.00.1003220951440.18642@pobox.suse.cz>
References: <20100320170014.440959a8@neptune.home> <20100320170241.55258b0d@neptune.home> <20100321034600.GE29360@core.coreip.homeip.net> <20100321173737.5fcf3580@neptune.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Mar 2010, Bruno Prémont wrote:

> > > +	}
> > > +	data->status |= PICOLCD_BUSY;
> > > +	data->pending = work;
> > > +	for (i = k = 0; i < report->maxfield; i++)
> > > +		for (j = 0; j < report->field[i]->report_count; j++) {
> > > +			hid_set_field(report->field[i], j, k < size ? raw_data[k] : 0);
> > > +			k++;
> > > +		}
> > > +	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
> > > +	complete_all(&data->ready);
> > > +	INIT_COMPLETION(data->ready);
> > 
> > Umm, what does this do, exactly?
> >
> It wakes up anyone waiting on the completion and then resets the completion
> as otherwise any future attempt to wait on it would succeed immediately.
> 
> The complete_all() instead of just complete() comes from the reset() function.
> I can probably reduce it here.
> 
> Will check this combined with your mutex suggestion above.

I am afraid this code is racy as is. You can't be sure that whoever has 
been waiting on the completion has been notified already between 
complete_all() and INIT_COMPLETION(), can you?

Thanks for the driver!

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
