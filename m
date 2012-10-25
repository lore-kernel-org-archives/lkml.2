Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab2JYHKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:10:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:57366 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756208Ab2JYHKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:10:31 -0400
Date: Thu, 25 Oct 2012 00:10:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?utf-8?B?5YqJ5ZiJ6ae/?= <scott.liu@emc.com.tw>
Cc: linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Benjamin Tissoires'" <benjamin.tissoires@gmail.com>,
        "'Jesse'" <jesse@emc.com.tw>,
        "'Vincent Wang'" <vincent.wang@emc.com.tw>,
        "'Paul'" <paul.liang@emc.com.tw>
Subject: Re: [PATCH v2] Support Elan Touchscreen eKTF product.
Message-ID: <20121025071026.GA23478@core.coreip.homeip.net>
References: <20121024181323.GA18122@core.coreip.homeip.net>
 <EA73774BB37B4F518A6EA9926BB96304@elan.corp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EA73774BB37B4F518A6EA9926BB96304@elan.corp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 12:32:39PM +0800, 劉嘉駿 wrote:
> Hi Dmitry,
> 	Thanks for review.
> 
> > -----Original Message-----
> > From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> > Sent: Thursday, October 25, 2012 2:13 AM
> > To: Scott Liu
> > Cc: linux-input@vger.kernel.org; linux-i2c@vger.kernel.org;
> linux-kernel@vger.kernel.org;
> > Benjamin Tissoires; Jesse; Vincent Wang; Paul
> > Subject: Re: [PATCH v2] Support Elan Touchscreen eKTF product.
> > 
> > Hi Scott,
> > 
> > On Wed, Oct 24, 2012 at 09:41:43AM +0800, Scott Liu wrote:
> > > This patch is for Elan eKTF Touchscreen product, I2C adpater module.
> > >
> > > Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
> > > ---
> > >
> > > Hi,
> > >         v2 revision I have fixed some bug as your advise.
> > >         1. To target the mainline
> > >         2. No Android dependency
> > >         3. reuse those duplication code from Henrik's patchset.
> > >                 (input_mt_sync_frame()  / input_mt_get_slot_by_key())
> > 
> > Just a quick run through the code, so:
> > 
> > - please remove polling support, it is not useful in production;
> 
> OK.
> 
> > - why do you need a separate probe work instead of doing what you
> >   need in elants_probe()
> 
> will fix.
> 
> > - it is not a good idea to register input device first and then
> >   allocating memory for MT handling.
> 
> Ooop...will fix.
> 
> > - I do not understand why kfifo is needed
> 
> The firmware and the host would conflict by read command and finger report
> simultaneously. So I'm simply using kfifo in IRQ thread function.
> 
> * read command: writing 4 bytes commands and the device asserts GPIO
> interrupt and then response 4 bytes data.
> 
> There was an error if we do not use kfifo:
> 	With heavy loading by finger report / read command, the driver may
> get finger report as response data.
> 
> So, do you understand my meaning? 

No I don't. Most of my confusion stems from the fact that you only put
data into kfifo but not actually use it anywhere. You do fetch the data
in your "drop old" function, but that data is just dropped. So I really
do not see the point.

Thanks.

-- 
Dmitry
