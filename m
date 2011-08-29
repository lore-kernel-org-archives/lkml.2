Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab1H2GEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 02:04:23 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:39993 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750738Ab1H2GES convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 02:04:18 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Pavel Ivanov <paivanof@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Mon, 29 Aug 2011 08:04:04 +0200
In-Reply-To: <20110829054926.GA7123@liondog.tnic>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
	 <1314435638.2321.12.camel@thor.local>
	 <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
	 <20110828053624.GC12851@liondog.tnic>
	 <CAG1a4rv8YirPpyYP735Zn3gpp-kcvvECd=-haZ-qx90_99x8aQ@mail.gmail.com>
	 <20110829054926.GA7123@liondog.tnic>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.1 
Message-ID: <1314597844.31972.32.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 07:49 +0200, Borislav Petkov wrote: 
> On Sun, Aug 28, 2011 at 05:47:59PM -0400, Pavel Ivanov wrote:
> > On Sun, Aug 28, 2011 at 1:36 AM, Borislav Petkov <bp@alien8.de> wrote:
> > >> > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
> > >> > loaded from userspace, so it needs to be built into the kernel as well.
> > >>
> > >> How should I do that? I've tried to set all "m"s to "y" in .config and
> > >> still saw this issue. Should I set some special parameter?
> > >
> > > You need to add "radeon/CEDAR_pfp.bin" to CONFIG_EXTRA_FIRMWARE when you
> > > configure your kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
> > >
> > > The radeon/CEDAR_pfp.bin file (+ leading directory, mind you) should
> > > most probably be located in /lib/firmware or to whatever you have set
> > > CONFIG_EXTRA_FIRMWARE_DIR so that Kbuild can find it (if not, you'll get
> > > a warning at the end of the kernel build). This way, it works for both
> > > radeon being =m and =y.
> > 
> > Everything else in /lib/firmware/radeon is needed after user space
> > become available?
> 
> You mean the other *.bin files? If so, not for your case, AFAICT - your
> driver is requesting CEDAR_pfp.bin only, correct?

It'll need all the CEDAR_*.bin files.


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
