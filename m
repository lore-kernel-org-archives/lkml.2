Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2IFGxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 02:53:43 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:47653 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab2IFGxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 02:53:42 -0400
Date: Thu, 6 Sep 2012 08:53:40 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Mack <zonque@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re:
Message-ID: <20120906065340.GA257@x4>
References: <s5hmx1526mg.wl%tiwai@suse.de>
 <20120906060220.GA252@x4>
 <504843BA.2040808@gmail.com>
 <s5hehmfir46.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hehmfir46.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.06 at 08:48 +0200, Takashi Iwai wrote:
> At Thu, 06 Sep 2012 08:33:30 +0200,
> Daniel Mack wrote:
> > 
> > On 06.09.2012 08:02, Markus Trippelsdorf wrote:
> > > On 2012.09.04 at 16:40 +0200, Takashi Iwai wrote:
> > >> ----------------------------------------------------------------
> > >> Sound fixes for 3.6-rc5
> > >>
> > >> There are nothing scaring, contains only small fixes for HD-audio and
> > >> USB-audio:
> > >> - EPSS regression fix and GPIO fix for HD-audio IDT codecs
> > >> - A series of USB-audio regression fixes that are found since 3.5 kernel
> > >>
> > >> ----------------------------------------------------------------
> > >> Daniel Mack (4):
> > >>       ALSA: snd-usb: Fix URB cancellation at stream start
> > >>       ALSA: snd-usb: restore delay information
> > >         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
> > > The commit fbcfbf5f above causes the following lines to be printed
> > > whenever I start a new song:
> > 
> > Copied Pierre-Louis Bossart - he wrote the code in 294c4fb8 which this
> > patch (fbcfbf5f) brings back now.
> > 
> > > delay: estimated 0, actual 352
> > > delay: estimated 353, actual 705
> > > 
> > > (44.1 * 8 = 352.8)
> > > 
> > > This happens with an USB-DAC that identifies itself as "C-Media USB
> > > Headphone Set".
> > 
> > And you didn't you see these lines with 3.4?
> 
> Maybe the difference of start condition?
> 
> Markus, does the patch below fix anything?

Unfortunately no.
However reverting the following fixes the problem:

commit 245baf983cc39524cce39c24d01b276e6e653c9e
Author: Daniel Mack <zonque@gmail.com>
Date:   Thu Aug 30 18:52:30 2012 +0200

    ALSA: snd-usb: fix calls to next_packet_size

-- 
Markus
