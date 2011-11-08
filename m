Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab1KHDsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:48:15 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:43278 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1KHDsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:48:13 -0500
Date: Mon, 7 Nov 2011 19:48:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: JJ Ding <jj_ding@emc.com.tw>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH] Input: convert obsolete strict_strtox to kstrtox
Message-ID: <20111108034805.GA21927@core.coreip.homeip.net>
References: <1320635570-18860-1-git-send-email-jj_ding@emc.com.tw>
 <20111107055540.GB21095@core.coreip.homeip.net>
 <87d3d4fok0.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3d4fok0.fsf@emc.com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi JJ,

On Mon, Nov 07, 2011 at 02:13:03PM +0800, JJ Ding wrote:
> Hi Dmitry,
> 
> Thanks for the hint. I will send a new patch.
> 
> Btw, there are still some simple_strtox uses floating around. Namely:
> 
> drivers/input/joystick/analog.c:735:            analog_options[i] = simple_strtoul(js[i], &end, 0);
> drivers/input/mouse/sentelic.c:415:     reg = simple_strtoul(buf, &rest, 16);
> drivers/input/touchscreen/gunze.c:71:   input_report_abs(dev, ABS_X, simple_strtoul(gunze->data + 1, NULL, 10));
> drivers/input/touchscreen/gunze.c:72:   input_report_abs(dev, ABS_Y, 1024 - simple_strtoul(gunze->data + 6, NULL, 10));
> 
> But I am not quite sure if it's safe to convert along the way. Is it OK
> to convert these?

I looked at these and I believe they do want to use simple_strtoul() as
they perform some more complex parsing there.

Thanks.

-- 
Dmitry
