Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2IFNSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:18:06 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:33869 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656Ab2IFNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:18:05 -0400
Date: Thu, 6 Sep 2012 15:17:58 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re: snd-usb: "delay: estimated 0, actual 352"
Message-ID: <20120906131758.GA256@x4>
References: <20120906060220.GA252@x4>
 <504843BA.2040808@gmail.com>
 <s5hehmfir46.wl%tiwai@suse.de>
 <20120906065340.GA257@x4>
 <50484BEB.4020103@gmail.com>
 <20120906071757.GB257@x4>
 <s5h627rioxt.wl%tiwai@suse.de>
 <s5hsjavh88c.wl%tiwai@suse.de>
 <20120906094348.GA257@x4>
 <s5hvcfrxpsc.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hvcfrxpsc.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.06 at 15:08 +0200, Takashi Iwai wrote:
> At Thu, 6 Sep 2012 11:43:48 +0200,
> Markus Trippelsdorf wrote:
> > 
> > On 2012.09.06 at 10:21 +0200, Takashi Iwai wrote:
> > > At Thu, 06 Sep 2012 09:35:26 +0200,
> > > Takashi Iwai wrote:
> > > 
> > > In short, a patch like below may fix the issue (note: completely
> > > untested!)
> > 
> > No it doesn't, unfortunately...
> 
> OK, I start tracking down the problem a bit more deeply now.
> 
> The issue happens when the first two URBs are passed to
> retire_playback_urb().  These are URBs filled before start_endpoints()
> are set, so they contain actually zero size.  Even though these are
> a sort of dummy packets, the driver still tries to check with the
> queued delay account, and gives bogus errors.
> 
> So, essentially the messages are harmless and nothing to worry too
> much, but surely it doesn't look sexy.
> 
> The patch below should fix the problem.  Please give it a try.

Yes, your patch finally fixes the problem. 
Thank you Takashi-san.

-- 
Markus
