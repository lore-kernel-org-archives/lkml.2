Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0JMSSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 14:18:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56208 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab0JMSSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:18:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VOXLkTIKWNzeMQJAOPg2ceuYfsB0JIvWjLYuXsnz45rq5WqIm1zszg6R3GubQChNB1
         X2C07lIfKbILxvE6TJW5u5Ba6k2ylxa/KKSvpO2s1wOX+4p29kCYS1/xD5P5hyK9VRDJ
         NbQY2g3pi6kfcKS4pb8+IaDLVIlPcq3GuTSlQ=
Date: Wed, 13 Oct 2010 11:18:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Vojtech Pavlik <vojtech@ucw.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] lockdep: check the depth of subclass
Message-ID: <20101013181844.GA13094@core.coreip.homeip.net>
References: <1286269311-28336-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
 <1286879221.29097.39.camel@twins>
 <20101012160352.GB30513@core.coreip.homeip.net>
 <4CB51922.2080405@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB51922.2080405@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 11:27:46AM +0900, Hitoshi Mitake wrote:
> On 10/13/10 01:03, Dmitry Torokhov wrote:
> > On Tue, Oct 12, 2010 at 12:27:01PM +0200, Peter Zijlstra wrote:
> >> On Tue, 2010-10-05 at 18:01 +0900, Hitoshi Mitake wrote:
> >>> ---
> >>>   drivers/input/mousedev.c |    2 +-
> >>>   kernel/lockdep.c         |   15 +++++++++++++++
> >>>   2 files changed, 16 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> >>> index d528a2d..9897334 100644
> >>> --- a/drivers/input/mousedev.c
> >>> +++ b/drivers/input/mousedev.c
> >>> @@ -866,7 +866,7 @@ static struct mousedev
> *mousedev_create(struct input_dev *dev,
> >>>   	spin_lock_init(&mousedev->client_lock);
> >>>   	mutex_init(&mousedev->mutex);
> >>>   	lockdep_set_subclass(&mousedev->mutex,
> >>> -			     minor == MOUSEDEV_MIX ? MOUSEDEV_MIX : 0);
> >>> +			     minor == MOUSEDEV_MIX ? SINGLE_DEPTH_NESTING : 0);
> >>
> >> Ah good find.
> >>
> >
> > I'll pick up mousedev change for .37.
> 
> Thanks a lot, Dmitry.
> 
> Should I divide this patch into two for
> drivers/input/mousedev.c and kernel/lockdep.c?
> If you need, I'll resend second version.

No, thanks, I'll extract it on my end.

-- 
Dmitry
