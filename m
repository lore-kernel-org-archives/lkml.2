Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0CVEfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 00:35:18 -0400
Received: from mail-yx0-f182.google.com ([209.85.210.182]:60316 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab0CVEfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 00:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=oA/4j199YdnnyQnnc3wFWimt4F5O3z24fZcM+Cq91UPrS+J9rwbrl+IUTHujwANBiY
         AI0LE/DAKJRZMbCh/jTmxdlIZMOutHqErjVdpJjW9W9MimjHaKNR41X5mPW0VoFV2Cca
         +3SGHMjlkEv+FjF9V09rWfBnv0FUe7JtjEEd0=
Date: Sun, 21 Mar 2010 21:35:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: Re: [PATCH v2 1/6] hid: new driver for PicoLCD device
Message-ID: <20100322043508.GC31621@core.coreip.homeip.net>
References: <20100320170014.440959a8@neptune.home>
 <20100320170241.55258b0d@neptune.home>
 <20100321034600.GE29360@core.coreip.homeip.net>
 <20100321173737.5fcf3580@neptune.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100321173737.5fcf3580@neptune.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 05:37:37PM +0100, Bruno Prémont wrote:
> On Sat, 20 March 2010 Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > +	usbhid_submit_report(data->hdev, report, USB_DIR_OUT);
> > > +	complete_all(&data->ready);
> > > +	INIT_COMPLETION(data->ready);
> > 
> > Umm, what does this do, exactly?
> 
> It wakes up anyone waiting on the completion and then resets the completion
> as otherwise any future attempt to wait on it would succeed immediately.
> 

You realize that if you re-initialize the completion right after
signalling it there is a big chance the waiters will miss it (they do
check completion->done flags that you reset right away.

In general completions are suited for something that happens once (a
single request - allocated - processed - signalled) but not for
repeating use.

Thanks.

-- 
Dmitry
