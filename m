Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1ALWNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:13:17 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2078 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1ALWNN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:13:13 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 12 Jan 2011 14:13:04 -0800
From: Rakesh Iyer <riyer@nvidia.com>
To: "'Pavel Machek'" <pavel@ucw.cz>
CC: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Date: Wed, 12 Jan 2011 14:13:00 -0800
Subject: RE: [PATCH 1/1] input: tegra-kbc - Add tegra keyboard driver
Thread-Topic: [PATCH 1/1] input: tegra-kbc - Add tegra keyboard driver
Thread-Index: AcuypHGOurzH6DkcRQ69amIakLiUbgAACOBQ
Message-ID: <1FC56210173BB445BD77F608D6FB8D03165A00806E@HQMAIL03.nvidia.com>
References: <1294869179-15102-1-git-send-email-riyer@nvidia.com>
 <1FC56210173BB445BD77F608D6FB8D03165A00806D@HQMAIL03.nvidia.com>
 <20110112220254.GA4214@elf.ucw.cz>
In-Reply-To: <20110112220254.GA4214@elf.ucw.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the list of changes. I was not sure of the protocol of adding this into the patch email.

a) Addressed all of Trilok Soni's comments excluding the tegra clk programming which is necessary.
Use correct labels in tegra_kbc_probe error paths. 
Identify and if necessary document all register accesses without using magic numbers.
Modify suspend to check for valid users before proceeding to close.
 
b) Removed the Fn keymap and its references. This obviated the need for some helper functions.

c) Setup the input device's keycodexx parameters.


Pavel's query

> But now I'm confused; does hardware have Fx keys (F10 above) or not?
> 									Pavel

The function key for this keyboard is separate from the F1 to F12 keys, where the latter are always available.

The function key serves just like a SHIFT key to overload the use of certain keys e.g. Fn+PgUP-> "Home", Fn+PgDn -> "End"

Regards
Rakesh
> -----Original Message-----
> From: Pavel Machek [mailto:pavel@ucw.cz]
> Sent: Wednesday, January 12, 2011 2:03 PM
> To: Rakesh Iyer
> Cc: tsoni@codeaurora.org; dmitry.torokhov@gmail.com; shubhrajyoti@ti.com;
> ccross@android.com; konkers@android.com; olof@lixom.net; Andrew Chew; linux-
> tegra@vger.kernel.org; linux-kernel@vger.kernel.org; linux-input@vger.kernel.org
> Subject: Re: [PATCH 1/1] input: tegra-kbc - Add tegra keyboard driver
> 
> On Wed 2011-01-12 13:59:45, Rakesh Iyer wrote:
> > Hi all.
> >
> > I apologize for not specifying the PATCH indicator as "PATCH v4".
> >
> > Sorry for the inconvenience caused.
> 
> Well, that is not huge problem, but short note of changes from last
> version would be welcome.
> 
> AFAICT, FN handling was reworked...?
> 
> > > +     KEY_F10, KEY_F9, KEY_BACKSPACE, KEY_3,
> > > +             KEY_2, KEY_UP, KEY_PRINT, KEY_PAUSE,
> 
> But now I'm confused; does hardware have Fx keys (F10 above) or not?
> 									Pavel
> 
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
