Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433Ab1H0JAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 05:00:55 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:46394 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751149Ab1H0JAy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 05:00:54 -0400
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Pavel Ivanov <paivanof@gmail.com>
Cc: dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 27 Aug 2011 11:00:38 +0200
In-Reply-To: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.0 
Message-ID: <1314435638.2321.12.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sam, 2011-08-27 at 00:20 -0400, Pavel Ivanov wrote: 
> 
> I observe very strange behavior dependent on value of
> CONFIG_DRM_RADEON parameter. When it's set to m everything works very
> good, no problem. When I set it to y I see kernel hang during boot. Or
> I should better say it "almost hangs" because during last boot attempt
> I accidentally waited a little bit longer and saw that after more than
> a minute waiting system continued to boot. Dmesg after "hang" shows
> these messages:
> 
> [    8.542639] [drm] Loading CEDAR Microcode
> [   69.161605] r600_cp: Failed to load firmware "radeon/CEDAR_pfp.bin"
> [   69.161670] [drm:evergreen_startup] *ERROR* Failed to load firmware!
> 
> While during normal boot
> 
> [    9.898870] [drm] Loading CEDAR Microcode
> [    9.908425] radeon 0000:05:00.0: WB enabled

With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
loaded from userspace, so it needs to be built into the kernel as well.


-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
