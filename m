Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab0DNOgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:36:40 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:51687 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab0DNOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:36:39 -0400
X-Spam-Flag: NO
X-Spam-Score: -24.389
Message-ID: <4BC5D2F4.4010500@tremplin-utc.net>
Date: Wed, 14 Apr 2010 16:36:36 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100331 Mandriva/3.0.4-1mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, Frank Griffin <ftg@roadrunner.com>
Subject: Re: [REGRESSION bisected] Sound goes too fast due to commit 7b3a177b0
References: <4BC4E812.6050602@tremplin-utc.net>	<s5h633u5zx1.wl%tiwai@suse.de>	<4BC5A566.8060106@tremplin-utc.net>	<4BC5AD08.8040606@tremplin-utc.net> <s5hy6gqxiev.wl%tiwai@suse.de>
In-Reply-To: <s5hy6gqxiev.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/10 15:39, Takashi Iwai wrote:
:
> 
> bdl_pos_adj is really a workaround for devices that report wrong DMA
> position (or at the wrong timing).  I guess position_fix=1 may fix
> better.
> 
> Although the driver already has a dynamic switching of position_fix
> method, it checks only the very first read.  If it gives a (more or
> less) sane value, it prefers the position-buffer method (corresponding
> to position_fix=2) rather than reading LPIB register
> (position_fix=1).
> 
> It seems, however, that more devices work sanely with LPIB reg
> nowdays.  This wasn't the case formerly.  So, it might be better to
> use position_fix=1 as default for modern systems...
Frank,
Could you check that for you too adding "position_fix=1" fixes the problem?

To do so, edit /etc/modprobe.conf and add this line at end:
options snd-hda-intel position_fix=1

You need to reboot for this to be taken into account.

Cheers,
Eric
