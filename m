Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab0JLQEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:04:08 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42288 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757258Ab0JLQEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 12:04:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TU6af6Vz82SGpApV52ugykQaLTlYqdi70BQhjgQGeq7HQ3MrDLgF05kDuePsmkPgoQ
         S+76Hu+DanhrAv931qlXI0d0x5BLtxOwbFuj4S6M3F/i03txcyJ/WAG6/SVwhWG3bgG2
         aaxBP2xT+PfdHewkrLNgUBlq64jxEcTuCsZ4c=
Date: Tue, 12 Oct 2010 09:03:53 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Vojtech Pavlik <vojtech@ucw.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] lockdep: check the depth of subclass
Message-ID: <20101012160352.GB30513@core.coreip.homeip.net>
References: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1286879221.29097.39.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286879221.29097.39.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 12:27:01PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-10-05 at 18:01 +0900, Hitoshi Mitake wrote:
> > ---
> >  drivers/input/mousedev.c |    2 +-
> >  kernel/lockdep.c         |   15 +++++++++++++++
> >  2 files changed, 16 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> > index d528a2d..9897334 100644
> > --- a/drivers/input/mousedev.c
> > +++ b/drivers/input/mousedev.c
> > @@ -866,7 +866,7 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
> >  	spin_lock_init(&mousedev->client_lock);
> >  	mutex_init(&mousedev->mutex);
> >  	lockdep_set_subclass(&mousedev->mutex,
> > -			     minor == MOUSEDEV_MIX ? MOUSEDEV_MIX : 0);
> > +			     minor == MOUSEDEV_MIX ? SINGLE_DEPTH_NESTING : 0);
> 
> Ah good find.
> 

I'll pick up mousedev change for .37.

Thanks.

-- 
Dmitry
