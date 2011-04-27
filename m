Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab1D0KpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:45:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45588 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757653Ab1D0KpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:45:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lcWyFPX9Bbti17fg3rannnFUC0wHozmFvx/LhNLpx+2aWXCVo4RPSaBJy8y3F2297o
         6W3Wzzk2zVzC4XCM+Swas/hmQzHdUSOewhG0RAlblGR7lNP4TsvNAfZX/obbQ0gREE9C
         4Z6uC5RidIVjGeTdn5n9JMFwzy/Q8NiACB1vg=
Subject: Re: [PATCH] Applying inappropriate ioctl operation on socket
 should return ENOTTY
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Lifeng Sun <lifongsun@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20110427104738.2bdbe228@lxorguk.ukuu.org.uk>
References: <1303882625-28115-1-git-send-email-lifongsun@gmail.com>
	 <1303883910.2699.53.camel@edumazet-laptop>
	 <20110427104738.2bdbe228@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 12:45:03 +0200
Message-ID: <1303901103.3166.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 27 avril 2011 à 10:47 +0100, Alan Cox a écrit :
> > EINVAL is ok too : Request or argp is not valid.
> 
> It confuses portable code in some situations
>  
> > I would say, its not a bug as you claim. 
> 
> POSIX and SuS tend to disagree
> 
> > Its really too late to make such change and risk regressions.
> 
> We've been quietly doing it for hundreds of cases including the entire
> tty driver. Almost nobody (you included) has actually noticed and in
> doing so we fixed various porting funnies without any reported
> regressions.
> 
> Networking may be a more tricky one (not that tty wasn't a large one we
> fixed) but most of the other driver ones are clearly sensible.
> 

Well, I wont argue the point, especially if you Ack the changes ;)

My only concern was to not break old applications, I dont know if it is
going to break _any_ of them. Probably these old applications stick with
old kernels.

If you ask me ENOTTY is plain wrong.
ioctl() is not restricted to terminal devices at all.

Any unknown ioctl command would return ENOTTY, regardless of fd being a
tty or not...

IF we add a new ioctl() to sockets in 2.6.42, using it on 2.6.41 would
give ENOTTY status, and EINVAL status on 2.6.24

Go figure...



