Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1H2Rin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 13:38:43 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:53352 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753560Ab1H2Rim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 13:38:42 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>, David Airlie <airlied@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Date: Mon, 29 Aug 2011 19:38:26 +0200
In-Reply-To: <20110829171750.GD2025@gere.osrc.amd.com>
References: <20110829141612.GB2025@gere.osrc.amd.com>
	 <1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	 <20110829155501.GC2025@gere.osrc.amd.com>
	 <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
	 <20110829171750.GD2025@gere.osrc.amd.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2 
Message-ID: <1314639506.30297.29.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-29 at 19:17 +0200, Borislav Petkov wrote: 
> On Mon, Aug 29, 2011 at 12:10:45PM -0400, Arnaud Lacombe wrote:
> > do you want something ala:
> > 
> > config EXTRA_FIRMWARE
> >     string
> >     default ""
> >     append "FOO" if BAR
> >     append "FOZ" if BAZ
> > 
> > or maybe a new type "list" which would behave as a comma/space separated value.
> > 
> > config EXTRA_FIRMWARE
> >     list "bla"
> >     append "FOO" if BAR
> >     append "FOZ" if BAZ
> 
> Yeah, actually Kyle's note (http://lkml.org/lkml/2011/8/29/289) makes
> much more sense for linux and the whole firmware in the kernel deal.
> So it looks like the drivers should be taught to wait for userspace to
> appear [...]

What would be the point of building radeon into the kernel then? It's
not gonna be active before the module could be loaded...


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
