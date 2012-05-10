Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2EJIcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 04:32:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34259 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab2EJIb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 04:31:58 -0400
Date: Thu, 10 May 2012 10:31:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] HID: hid-multitouch: fix wrong protocol detection
In-Reply-To: <20120509195632.GA12406@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1205101026010.31253@pobox.suse.cz>
References: <1336136030-18503-1-git-send-email-benjamin.tissoires@gmail.com> <1336136030-18503-2-git-send-email-benjamin.tissoires@gmail.com> <20120506190146.GA12571@polaris.bitmath.org> <CAN+gG=G9y_0Le-Mja2z68r76nBmz0De95Lc6671EkrrMZRSEHw@mail.gmail.com>
 <20120509195632.GA12406@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Henrik Rydberg wrote:

> > well, the idea was to keep the memory footprint low. As these values
> > are only needed at init, then I freed them once I finished using them.
> > I can of course skip the pointer, but in that case, wouldn't the
> > struct declaration be worthless?
> 
> My bad, I misread the placement of the free() statement. I was also
> concerned about memory, since HID is big enough a memory hog as it
> is. Barring the added complexity of this patch, it now makes more
> sense.
> 
>     Acked-by: Henrik Rydberg <rydberg@euromail.se>

drivers/hid/hid-multitouch.c: In function ¡mt_post_parse¢:
drivers/hid/hid-multitouch.c:673: error: invalid type argument of ¡->¢ (have ¡unsigned int¢)
make[1]: *** [drivers/hid/hid-multitouch.o] Error 1

I believe that

	td->last_slot_field = f->usages[field_count_per_touch - 1]->hid;

should be

	td->last_slot_field = f->usages[field_count_per_touch - 1];

but I leave this up to you guys to fix.

Thanks,

-- 
Jiri Kosina
SUSE Labs
