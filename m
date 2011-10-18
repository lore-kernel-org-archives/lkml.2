Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab1JRUje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 16:39:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3401 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1JRUjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 16:39:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=j7GvAI63S0jYH4ZAulrNrHkbKrDBsD4MwTyb6R0/QP6snCE+XS0wDK7+yy91sDqTg
	VWV8tFF+AEHcTUTVihZow==
Date: Tue, 18 Oct 2011 13:39:27 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Antonio Ospite <ospite@studenti.unina.it>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
cc: "Tomas M." <tmezzadra@gmail.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: kernel OOPS when releasing usb webcam (random)
In-Reply-To: <20111018104054.07aa2bcf462c0268a23c0139@studenti.unina.it>
Message-ID: <alpine.DEB.2.00.1110181332320.2639@chino.kir.corp.google.com>
References: <4E9CB0C2.3030902@gmail.com> <alpine.DEB.2.00.1110171703210.13515@chino.kir.corp.google.com> <20111018104054.07aa2bcf462c0268a23c0139@studenti.unina.it>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Antonio Ospite wrote:

> > > im getting the following null pointer dereference from time to time when
> > > releasing a usb camera.
> > > 
> > > maybe this trace is of assistance...please reply to my mail since im not
> > > subscribed.
> > > 
> > 
> > I suspect this is happening in v4l2_device_unregister_subdev().  Adding 
> > Guennadi, Mauro, and linux-media.
> > 
> > > BUG: unable to handle kernel NULL pointer dereference at 0000006c
> > > IP: [<f90be6c2>] v4l2_device_release+0xa2/0xf0 [videodev]
> 
> Hi,
> 
> I sent a fix for a similar trace last week:
> http://patchwork.linuxtv.org/patch/8124/
> 
> Tomas, can you test it fixes the problem for you too?
> 

Tomas reported that the same change from Frederik Deweerdt fixed the 
issue, so you can add his tested-by from 
https://lkml.org/lkml/2011/10/18/298.

Guennadi or Mauro, how is this going to Linus?  It sounds like 3.1 
material since we've received at least a couple of reports of this in the 
past week.
