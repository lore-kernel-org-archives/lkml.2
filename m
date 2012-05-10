Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094Ab2EJJhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:37:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab2EJJhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:37:14 -0400
Date: Thu, 10 May 2012 11:37:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
In-Reply-To: <CAN+gG=HJQxvFvCDf4LkYcvG3th4dyNFTNy8LzCZcq=gqo97p-w@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1205101136330.31253@pobox.suse.cz>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com> <1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com> <20120506190146.GA12571@polaris.bitmath.org> <CAN+gG=G9y_0Le-Mja2z68r76nBmz0De95Lc6671EkrrMZRSEHw@mail.gmail.com>
 <20120509195632.GA12406@polaris.bitmath.org> <alpine.LNX.2.00.1205101026010.31253@pobox.suse.cz> <CAN+gG=HJQxvFvCDf4LkYcvG3th4dyNFTNy8LzCZcq=gqo97p-w@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012, Benjamin Tissoires wrote:

> >> > well, the idea was to keep the memory footprint low. As these values
> >> > are only needed at init, then I freed them once I finished using them.
> >> > I can of course skip the pointer, but in that case, wouldn't the
> >> > struct declaration be worthless?
> >>
> >> My bad, I misread the placement of the free() statement. I was also
> >> concerned about memory, since HID is big enough a memory hog as it
> >> is. Barring the added complexity of this patch, it now makes more
> >> sense.
> >>
> >>     Acked-by: Henrik Rydberg <rydberg@euromail.se>
> >
> > drivers/hid/hid-multitouch.c: In function ‘mt_post_parse’:
> > drivers/hid/hid-multitouch.c:673: error: invalid type argument of ‘->’ (have ‘unsigned int’)
> > make[1]: *** [drivers/hid/hid-multitouch.o] Error 1
> >
> > I believe that
> >
> >        td->last_slot_field = f->usages[field_count_per_touch - 1]->hid;
> >
> > should be
> >
> >        td->last_slot_field = f->usages[field_count_per_touch - 1];
> 
> Ouch, indeed. the "->hid" is extra. When I split the patch 1 and 5, I
> missed that one.
> 
> I tested it without the ->hid, and it's good. Do I need to resend the patch?

No, that's fine, I have fixed that up and applied.

I am not applying the rest of the patchset yet.

-- 
Jiri Kosina
SUSE Labs
