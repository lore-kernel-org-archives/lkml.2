Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab2JDJsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 05:48:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2JDJsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 05:48:43 -0400
Date: Thu, 4 Oct 2012 11:48:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Jean Delvare <khali@linux-fr.org>,
        Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification
 implementation
In-Reply-To: <CAN+gG=H1BWmA_VW_RrhYWVU7qXrqbzhGCkkY0_41muL=XqJbjA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1210041145410.9942@pobox.suse.cz>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com> <20121003164306.GA18529@core.coreip.homeip.net> <CAN+gG=H1BWmA_VW_RrhYWVU7qXrqbzhGCkkY0_41muL=XqJbjA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Benjamin Tissoires wrote:

> >> +
> >> +     hid->claimed = 0;
> >
> > Should it be here and not in core?
> 
> This is a line that was copied/pasted from usbhid. I'll check how can
> I do that without interfering with core.


Well, we are calling ll_driver->stop at multiple places, so having this 
reset in the actual ll driver callback seems to be cleaner.

(if I understand the concern here correctly).

-- 
Jiri Kosina
SUSE Labs
