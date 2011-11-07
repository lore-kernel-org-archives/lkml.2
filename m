Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1KGGP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 01:15:28 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:43718 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab1KGGP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 01:15:27 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH] Input: convert obsolete strict_strtox to kstrtox
In-Reply-To: <20111107055540.GB21095@core.coreip.homeip.net>
References: <1320635570-18860-1-git-send-email-jj_ding@emc.com.tw> <20111107055540.GB21095@core.coreip.homeip.net>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 07 Nov 2011 14:13:03 +0800
Message-ID: <87d3d4fok0.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thanks for the hint. I will send a new patch.

Btw, there are still some simple_strtox uses floating around. Namely:

drivers/input/joystick/analog.c:735:            analog_options[i] = simple_strtoul(js[i], &end, 0);
drivers/input/mouse/sentelic.c:415:     reg = simple_strtoul(buf, &rest, 16);
drivers/input/touchscreen/gunze.c:71:   input_report_abs(dev, ABS_X, simple_strtoul(gunze->data + 1, NULL, 10));
drivers/input/touchscreen/gunze.c:72:   input_report_abs(dev, ABS_Y, 1024 - simple_strtoul(gunze->data + 6, NULL, 10));

But I am not quite sure if it's safe to convert along the way. Is it OK
to convert these?

Thanks,
jj

On Sun, 6 Nov 2011 21:55:40 -0800, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> Hi JJ,
> 
> On Mon, Nov 07, 2011 at 11:12:50AM +0800, JJ Ding wrote:
> > From: JJ Ding <dgdunix@gmail.com>
> > 
> > With commit 67d0a0754455f89ef3946946159d8ec9e45ce33a we mark strict_strtox
> > as obsolete. Convert all remaining such uses in drivers/input/.
> 
> Most of these users do not want long data, they just want an int, but
> strict_strtouint was not available. Since we have kstrtouint now it
> would be nice to use it.
> 
> Thanks.
> 
> -- 
> Dmitry
