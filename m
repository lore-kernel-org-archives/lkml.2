Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab1DMMM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:12:57 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:56459 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755500Ab1DMMMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:12:55 -0400
Subject: Re: Revert 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Gabriel Paubert <paubert@iram.es>
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Date: Wed, 13 Apr 2011 14:12:16 +0200
In-Reply-To: <20110413075943.GA27996@iram.es>
References: <20110406084101.GB13963@pengutronix.de>
	 <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
	 <20110406204327.GA11148@iram.es> <1302185075.24704.143.camel@thor.local>
	 <20110411133128.GA24344@iram.es> <1302535963.24704.268.camel@thor.local>
	 <20110412113033.GA16649@iram.es> <1302608770.27054.36.camel@thor.local>
	 <20110412120055.GA7995@iram.es> <1302629362.15520.25.camel@thor.local>
	 <20110413075943.GA27996@iram.es>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.0- 
Message-ID: <1302696736.15520.63.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-04-13 at 09:59 +0200, Gabriel Paubert wrote: 
> On Tue, Apr 12, 2011 at 07:29:22PM +0200, Michel Dänzer wrote:
> > On Die, 2011-04-12 at 14:00 +0200, Gabriel Paubert wrote:
> > > On Tue, Apr 12, 2011 at 01:46:10PM +0200, Michel Dänzer wrote:
> > > > > 
> > > > > With no_wb=1 the driver goes a bit further but the X server ends
> > > > > up in an infinite ioctl loop and the logs are: 
> > > > 
> > > > Which ioctl does it loop on? Please provide the Xorg.0.log file as well.
> > > 
> > > From memory, the code was 0x64, which is DRM_RADEON_GEM_WAIT_IDLE.
> > 
> > Note that it's normal for this ioctl to be called every time before the
> > GPU accessible pixmap memory is accessed by the CPU. Unless the ioctl
> > always returns an error, this may not indicate a problem on its own. 
> 
> It seems to be an infinite loop, always returning EINTR because
> of regular SIGALRM delivery.

That does sound like the GPU locks up. Do you get any messages in dmesg
about lockups and attempts to reset the GPU at any time?


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
