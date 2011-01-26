Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1AZRAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:00:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59893 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab1AZRAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:00:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZNbuwgo7Xtmy7ezlKJzp+tynGFC6WD85lz28aHS/UdgL0Kj37qzbOtfGUY/s/gJeE0
         1gnOMAsdias3GjhpqNrrHF3D6ch375sBEAre501eI0VgLqsFH9UPj+CcEk4/Edyi78iv
         KRR6H1ruMNPyVPJeC6gWPr9t8MNL1fg67f7BY=
Date: Wed, 26 Jan 2011 09:00:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Engraf <david.engraf@sysgo.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serio: allow registered drivers to get status flag
Message-ID: <20110126170043.GB29168@core.coreip.homeip.net>
References: <4D358E31.4080700@sysgo.com>
 <20110118195710.GA27152@core.coreip.homeip.net>
 <4D37FAEF.8080504@sysgo.com>
 <4D3FEB2A.8010000@sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3FEB2A.8010000@sysgo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:36:42AM +0100, David Engraf wrote:
> Am 20.01.2011 10:05, schrieb David Engraf:
> >Am 18.01.2011 20:57, schrieb Dmitry Torokhov:
> >>On Tue, Jan 18, 2011 at 01:57:21PM +0100, David Engraf wrote:
> >>>Parse the status byte information to the registered serio drivers as
> >>>well as the character bytes.
> >>>
> >>>Signed-off-by: David Engraf<david.engraf@sysgo.com>
> >>>
> >>
> >>>--- linux-2.6.37/drivers/input/serio/serport.c.orig 2011-01-18
> >>>12:33:41.421709232 +0100
> >>>+++ linux-2.6.37/drivers/input/serio/serport.c 2011-01-18
> >>>13:33:24.521711214 +0100
> >>>@@ -116,8 +116,8 @@ static void serport_ldisc_close(struct t
> >>>
> >>>/*
> >>>* serport_ldisc_receive() is called by the low level tty driver when
> >>>characters
> >>>- * are ready for us. We forward the characters, one by one to the
> >>>'interrupt'
> >>>- * routine.
> >>>+ * are ready for us. We forward the characters and flags, one by one
> >>>to the
> >>>+ * 'interrupt' routine.
> >>>*/
> >>>
> >>>static void serport_ldisc_receive(struct tty_struct *tty, const
> >>>unsigned char *cp, char *fp, int count)
> >>>@@ -132,7 +132,7 @@ static void serport_ldisc_receive(struct
> >>>goto out;
> >>>
> >>>for (i = 0; i< count; i++)
> >>>- serio_interrupt(serport->serio, cp[i], 0);
> >>>+ serio_interrupt(serport->serio, cp[i], fp[i]);
> >>>
> >>
> >>Hi David,
> >>
> >>The flags argument that serio_interrupt() accepts not the raw protocol
> >>data, but sanitized, protocol-independent SERIO_TIMEOUT, SERIO_PARITY
> >>and SERIO_FRAME bits.
> >>
> >>Thanks.
> >>
> >
> >Hi Dmitry,
> >
> >I've updated the patch so that the raw protocol is converted to the
> >SERIO_ bits. The raw protocol can parse only one flag, so I don't need
> >to store multiple SERIO_ bits in the character flag variable.
> >
> >Thanks
> >- David
> >
> >
> >Signed-off-by: David Engraf<david.engraf@sysgo.com>
> >
> 
> Hi Dmitry,
> 
> is my last patch okay for you? Just want to know if I can give you
> further help on this and if it is planned to integrate my patch.
> 

Hi David,

The patch should hit mainline real soon now, no action is needed on your
part.

Thanks.

-- 
Dmitry
