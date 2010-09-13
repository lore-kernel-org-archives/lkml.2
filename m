Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0IMIDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:03:36 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:52578 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754543Ab0IMIDe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:03:34 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Sep 2010 04:03:33 EDT
X-Quarantine-ID: <05cqhsVFapW6>
X-Amavis-Alert: BAD HEADER, Improper folded header field made up entirely of
	whitespace (char 09 hex): Face: ...MWASAkVVViQjzP\n jycPrvgA\n\t\n
	R1goSzOnkp14Y[...]
Subject: Re: [PATCH] radeon: Expose backlight class device for legacy LVDS
 encoder
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <1283963539-4039-3-git-send-email-mjg@redhat.com>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com>
	 <1283963539-4039-3-git-send-email-mjg@redhat.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA	
 R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 09:54:31 +0200
Message-ID: <1284364471.6653.137.camel@thor.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2010-09-08 at 12:32 -0400, Matthew Garrett wrote: 
> From: Michel Dänzer <michel@daenzer.net>
> 
> Allows e.g. power management daemons to control the backlight level. Inspired
> by the corresponding code in radeonfb.
> 
> (Updated to add backlight type and make the connector the parent device - mjg)
> 
> Signed-off-by: Michel Dänzer <daenzer@vmware.com>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>

Thanks for picking this up, Matthew.

Unfortunately, it fails to build here:

  CC [M]  drivers/gpu/drm/radeon/radeon_legacy_encoders.o
drivers/gpu/drm/radeon/radeon_legacy_encoders.c: In function ‘radeon_legacy_backlight_init’:
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:358: error: implicit declaration of function ‘pmac_has_backlight_type’
drivers/gpu/drm/radeon/radeon_legacy_encoders.c:403: error: implicit declaration of function ‘machine_is_compatible’
make[1]: *** [drivers/gpu/drm/radeon/radeon_legacy_encoders.o] Error 1
make: *** [_module_drivers/gpu/drm/radeon] Error 2

Am I missing changes from another tree?


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
