Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1I0Jee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:34:34 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:53578 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856Ab1I0JeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:34:22 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
Organization: LINBIT
To: Kyle Moffett <kyle@moffetthome.net>
Subject: Re: [PATCH 08/10] drbd: Introduce protocol version 100 headers
Date: Tue, 27 Sep 2011 11:34:04 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-generic; KDE/4.6.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        drbd-dev@lists.linbit.com
References: <1316788285-17433-1-git-send-email-philipp.reisner@linbit.com> <1316788285-17433-9-git-send-email-philipp.reisner@linbit.com> <CAGZ=bqJMKZ=MK+GXSXWCPVCecXHQv_15AT9Dxq2wxfcA_gNdMA@mail.gmail.com>
In-Reply-To: <CAGZ=bqJMKZ=MK+GXSXWCPVCecXHQv_15AT9Dxq2wxfcA_gNdMA@mail.gmail.com>
X-OTRS-FollowUp-SenderType: agent
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271134.05157.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 23. September 2011, 19:42:52 schrieb Kyle Moffett:
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
> >  drivers/block/drbd/drbd_int.h      |    8 ++++++++
> >  drivers/block/drbd/drbd_main.c     |   31
> > +++++++++++++++++++++++++------ drivers/block/drbd/drbd_receiver.c |  
> > 14 ++++++++++++--
> >  include/linux/drbd.h               |    1 +
> >  4 files changed, 46 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/block/drbd/drbd_int.h
> > b/drivers/block/drbd/drbd_int.h index 9868518..7d679c5 100644
> > --- a/drivers/block/drbd/drbd_int.h
> > +++ b/drivers/block/drbd/drbd_int.h
> > @@ -307,6 +307,14 @@ struct p_header95 {
> >        u32       vol_n_len;    /* big endian: high byte = volume;
> > remaining 24 bit = length */ } __packed;
> > 
> > +struct p_header100 {
> > +       u32       magic;
> > +       u16       volume;
> > +       u16       command;
> > +       u32       length;
> > +       u32       pad;
> > +} __packed;
> > +
> 
> This commit also needs additional log message text,
> specifically something that indicates what is new and
> different between the protocol 95 and protocol 100
> headers.  (IE: Why was the change made?)
> 

I merged patch 10/10 to this one. The updated, and merged
commit message is:

Author: Andreas Gruenbacher <agruen@linbit.com>
Date:   Wed Mar 30 16:00:17 2011 +0200

    drbd: Introduce protocol version 100 headers
    
    The 8 byte header finally becomes too small. With the protocol 100 header we
    have 16 bit for the volume number, proper 32 bit for the data length, and
    32 bit for further extensions in the future.
    
    Previous versions of drbd are using version 80 headers for all packets
    short enough for protocol 80.  They support both header versions in
    worker context, but only version 80 headers in asynchronous context.
    For backwards compatibility, continue to use version 80 headers for
    short packets before protocol version 100.
    
    From protocol version 100 on, use the same header version for all
    packets.
    
    Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
    Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>

Best,
 Phil
-- 
: Dipl-Ing Philipp Reisner
: LINBIT | Your Way to High Availability
: Tel: +43-1-8178292-50, Fax: +43-1-8178292-82
: http://www.linbit.com

DRBD(R) and LINBIT(R) are registered trademarks of LINBIT, Austria.
