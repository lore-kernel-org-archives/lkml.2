Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab1I0JeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:34:17 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:53560 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1I0JeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:34:16 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 04/10] drbd: Replace and remove old primitives
Date: Tue, 27 Sep 2011 11:34:01 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com> <1316788285-17433-5-git-send-email-philipp.reisner@linbit.com> <CAGZ=bqJ_b54h9xid_PNwz-Ag6aNuvyUHx2QCm5UXpdc-JvHhKQ@mail.gmail.com>
In-Reply-To: <CAGZ=bqJ_b54h9xid_PNwz-Ag6aNuvyUHx2QCm5UXpdc-JvHhKQ@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271134.02299.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 23. September 2011, 19:33:45 schrieb Kyle Moffett:
> Hi!
> 
> On Fri, Sep 23, 2011 at 10:31, Philipp Reisner
> 
> <philipp.reisner@linbit.com> wrote:
> > From: Andreas Gruenbacher <agruen@linbit.com>
> > 
> > Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
> > Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> > ---
> >  drivers/block/drbd/drbd_int.h      |   45 +----
> >  drivers/block/drbd/drbd_main.c     |  502
> > ++++++++++++++++-------------------- drivers/block/drbd/drbd_receiver.c
> > |   86 ++++---
> >  drivers/block/drbd/drbd_worker.c   |   24 +-
> >  4 files changed, 294 insertions(+), 363 deletions(-)
> 
> I'm afraid this commit is waaaaay too large and complicated
> to have a one-line commit message.
> 
> You should either split this up into more pieces or you should
> write a detailed log indicated what this is supposed to be doing
> and why it is OK.  (Or both).
> 

I updated the patch to the following commit message:

Author: Andreas Gruenbacher <agruen@linbit.com>
Date:   Mon Mar 28 14:23:08 2011 +0200

    drbd: Replace and remove old primitives
    
    Centralize sock->mutex locking and unlocking in [drbd|conn]_prepare_command()
    and [drbd|conn]_send_comman().
    
    Therefore all *_send_* functions are touched to use these primitives instead
    of drbd_get_data_sock()/drbd_put_data_sock() and former helper functions.
    
    That change makes the *_send_* functions more standardized.
    
    Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
    Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>


The complete, updated set is available at:
git://git.drbd.org/linux-2.6-drbd.git for-jens

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
