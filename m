Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0FHA2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:28:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49771 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab0FHA2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R0vQCV9zWqnLJmCAILL2jHq4s5r7U/i8RYjhieWTWv3lvzMMf/FAfl6tASFKAOblQY
         40tyk1SLAUeyj6frp9AI+jVAFcn44uCxTO7q1xByokUCCqR4aDUqmOcTrmgy+ZJQ3JWC
         5cOx3iKTuFoBhNpdj0FxI2pb55DV4k8+v2Qwk=
MIME-Version: 1.0
In-Reply-To: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com>
References: <AANLkTilOTKdY_2rQ6byxDIer_Ns-Ny0V0sM0rV9AuEkB@mail.gmail.com>
Date: Tue, 8 Jun 2010 08:28:04 +0800
Message-ID: <AANLkTil-FDegKlQv0qbo-6DScePQtodiFAQUi3ze-5LR@mail.gmail.com>
Subject: Re: broadsheetfb and fbcon
From: Jaya Kumar <jayakumar.lkml@gmail.com>
To: Robert Emanuele <rob@emanuele.us>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 6, 2010 at 7:21 AM, Robert Emanuele <rob@emanuele.us> wrote:
> real issue is when it tries to scroll the screen, it redraws each line
> partially and then does a full screen update with each partial line.

Sounds like what to expect because fbcon is using the slow path with
synchronous updates. It should be relatively straightforward to
improve that by reusing the deferred handler.

> It seems the driver is capable from Jaya's video at
> http://www.youtube.com/watch?v=0Bny6qyRDWw
>
> Are those kind of updates a limit of the broadsheet driver or fbcon?

That demo was horribly slow because it was host limited by the
xres*yres*16 gpio calls. That video was made before using batch
gpiolib support, which is a patchset that's out of tree,
http://thread.gmane.org/gmane.linux.fbdev.devel/13285 .

I had better results here, http://www.youtube.com/watch?v=aoG7XHO7P0s
and I was able to support 8Hz video,
http://www.youtube.com/watch?v=i4Loe5rIu4I (not display limited but
host limited). I had posted all of the code for that for review on
fbdev a while back, but I decided against getting it merged because it
wasn't elegant (needed userspace changes) and I think we can do
better. I'm trying to find time/funding to make those improvements.

Thanks,
jaya
