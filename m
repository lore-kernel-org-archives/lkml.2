Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab2FGJAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:00:52 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:29317 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755273Ab2FGJAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:00:50 -0400
Message-ID: <4FD06DA8.8090306@snewbury.org.uk>
Date: Thu, 07 Jun 2012 10:00:24 +0100
From: Steven Newbury <steve@snewbury.org.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120530 Thunderbird/12.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ALSA: hda - HDMI Audio init all connectors
References: <1339048379.2910.9.camel@Nokia-N900> <s5hd35b7bk4.wl%tiwai@suse.de>
In-Reply-To: <s5hd35b7bk4.wl%tiwai@suse.de>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=OH90f2hQQRgA:10 a=1AGrrh2Las4A:10 a=8nJEP1OIZ-IA:10 a=xqWC_Br6kY4A:10 a=N1CowNylAAAA:8 a=xe8BsctaAAAA:8 a=AchURstAsFJlKHtw9_YA:9 a=wPNLvfGTeEIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/06/12 09:47, Takashi Iwai wrote:
> At the next time you submit a patch, please add Cc to maintainer
> and subsystem ML.  Otherwise it'd be easily overlooked.
> 
I meant to, somehow I managed to send it off before adding the CC,
probably too early in the morning!

> At Thu, 07 Jun 2012 06:52:59 +0100, Steven Newbury wrote:
>> 
>> When VGA_SWITCHEROO support is enabled hda_intel initialises the
>> HDMI audio device on the current VGA device.  When it's not
>> enabled it only initialises the HDMI device on the default VGA
>> adaptor, this means secondary cards get no audio support which is
>> very unhelpful for multi-seat!
>> 
>> With this patch, when SUPPORT_VGA_SWITCHEROO is disabled
>> hda_intel initialises all HDMI audio devices, not just the
>> default VGA.
>> 
>> Signed-off-by: Steven Newbury <steve@snewbury.org.uk>
> 
> OK, it must be fixed indeed.  The bug was introduced due to the
> change in VGA-switcheroo side -- originally check_hdmi_disabled()
> really checked the VGA-switcheroo state, so it returned the correct
> value in the earlier version.
> 
> In anyway, your patch looks almost OK, but it'd be better to move 
> ifdef and simplify like below.  Could you check whether it works
> for you?
> 
Looks better, saves the pointless function call. I'll give it spin on
my next boot.

> Also, please give a patch that is applicable directly via git-am. 
> Apparently you created it via git show.  Instead, use
> git-format-patch or use --pretty=email for git-show.  Or, send the
> patch directly via git-send-email.
> 
I think it's the first time I've attempted to send a complete patch to
LKML (in the git era at least), rather than just a one-liner.  Thanks
for the tips, hopefully I'll get it right next time! :)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/QbacACgkQGcb56gMuC6226wCffwsBXTF7M2MhmUgggleo4gHB
v1MAoIwXx4REh1lSEEVhsGRuFQBZEs0q
=R4Ys
-----END PGP SIGNATURE-----
