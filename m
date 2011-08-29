Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1H2QMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:12:25 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34868 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753946Ab1H2QMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:12:21 -0400
Date: Mon, 29 Aug 2011 09:12:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Cheng Renquan <crquan@gmail.com>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nir Tzachar <nir.tzachar@gmail.com>
Subject: Re: [RFC] nconf bug fixes and improvements
Message-Id: <20110829091218.84ac35f5.rdunlap@xenotime.net>
In-Reply-To: <CACqU3MVRY6TvSJMOHzKTaF+Y=m8EtH=vaBT-_aTNqvLtnPVmLg@mail.gmail.com>
References: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
	<CACqU3MVRY6TvSJMOHzKTaF+Y=m8EtH=vaBT-_aTNqvLtnPVmLg@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011 10:14:00 -0400 Arnaud Lacombe wrote:

> Hi,
> 
> On Mon, Aug 29, 2011 at 5:09 AM, Cheng Renquan <crquan@gmail.com> wrote:
> > bug fixes:
> >
> Please split diff in logical changes, one patch per issue. This is
> unreviewable in the current state. And please, use git.

Agree with all except "use git".  This is a small patch (series).
git is not needed.

> See `Documentation/SubmittingPatches' for further informations.

At least the patch path names need to be fixed.

> Thanks,
>  - Arnaud
> 
> > 1) char dialog_input_result[256]; is not enough for config item like:
> >   CONFIG_EXTRA_FIRMWARE="iwlwifi-100-5.ucode iwlwifi-1000-3.ucode
> > iwlwifi-3945-2.ucode iwlwifi-4965-2.ucode iwlwifi-5000-1.ucode
> > iwlwifi-5000-2.ucode iwlwifi-5150-2.ucode iwlwifi-6000-4.ucode
> > iwlwifi-6000g2a-5.ucode iwlwifi-6000g2b-5.ucode iwlwifi-6050-4.ucode
> > iwlwifi-6050-5.ucode radeon/CEDAR_me.bin radeon/CEDAR_pfp.bin
> > radeon/CEDAR_rlc.bin radeon/CYPRESS_me.bin radeon/CYPRESS_pfp.bin
> > radeon/CYPRESS_rlc.bin radeon/JUNIPER_me.bin radeon/JUNIPER_pfp.bin
> > radeon/JUNIPER_rlc.bin radeon/R600_rlc.bin radeon/R700_rlc.bin
> > radeon/REDWOOD_me.bin radeon/REDWOOD_pfp.bin radeon/REDWOOD_rlc.bin"
> >
> >   the original nconf just stack overflow / crashed when dealing with
> > longer than 256 bytes strings; Since the original menuconfig also just
> > uses a fixed length buffer [MAX_LEN=2048] which works for the years,
> > here I just append a 0 make it work in the easiest way; if required,
> > it could also be changed to a dynamically allocated buffer;
> >
> >   char dialog_input_result[MAX_LEN + 1];
> >
> > 2) memmove's 3rd argument should be len-cursor_position+1, the
> > original len+1 may cause segment fault in theory;
> >                                memmove(&result[cursor_position+1],
> >                                                &result[cursor_position],
> > -                                               len+1);
> > +                                               len-cursor_position+1);
> >
> > 3) typo:
> >
> > -                               mvprintw(0, 0, "unknow key: %d\n", res);
> > +                               mvprintw(0, 0, "unknown key: %d\n", res);
> >
> >
> > improvement:
> > 1) its original conf_string doesn't work with longer string values
> > (longer than its dialog box width), not at all
> >   (or may work in an invisible way if anyone has tried that)
> >   Here I added a new variable cursor_form_win to record that new state:
> >   cursor of the input box; and make it fun:
> >   when you move cursor to almost left/right edge, it auto adjust text
> > to center, by half prompt box width;
> >
> > 2) Remove KEY_UP as RIGHT and KEY_DOWN as LEFT,
> >   Add Home/End to locate the string begin/end;
> >   Emacs-like key bind (C-a/C-e as Home/End, C-f/C-b as forward/backward);
> >   this keybind I'd like but may be controversial, it could be
> > discussed and separated;
> >
> > This is just [Request for Comments], it just works here on one of my
> > distributor kernels,
> > if anyone may think it's useful, please feedback and I would like to
> > split it into
> > patch series and rebase to linus latest branch;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
