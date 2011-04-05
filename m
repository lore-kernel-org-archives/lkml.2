Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab1DESRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:17:13 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51165 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab1DESRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vOILPj1Vs3E8z3i/qZD5UhcYcH/AEpg/eSnoHhLvK4J4hItLzCSFDn/Aeuhx0Zdk2P
         Ws+kTLOnisY92j9ZDxv+1Rfy10Is5CJWByR4+8jR0xM/jNRKlztcfZfB8tZNL+WqVoTH
         oSm423lDo9jf+9HPQ5qEdzhpfT31S/x3U5630=
Date: Tue, 5 Apr 2011 13:17:01 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Toth <stoth@kernellabs.com>
Subject: Re: [RFC/PATCH v2 0/7] locking fixes for cx88
Message-ID: <20110405181700.GA28181@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
 <20110405032014.GA4498@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405032014.GA4498@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Nieder wrote:

> Jonathan Nieder (7):
>   [media] cx88: protect per-device driver list with device lock
>   [media] cx88: fix locking of sub-driver operations
>   [media] cx88: hold device lock during sub-driver initialization
>   [media] cx88: use a mutex to protect cx8802_devlist
>   [media] cx88: handle attempts to use unregistered cx88-blackbird
>     driver
>   [media] cx88: don't use atomic_t for core->mpeg_users
>   [media] cx88: don't use atomic_t for core->users

Good news: Andreas Huber <hobrom@gmx.at> tested on a PC with 2
Hauppauge HVR1300 TV cards.

He writes:

> Hi Jonathan, I'm glad to say it works! No more deadlocks,
> no more reference count issues.
>
> I did some stress testing on the driver load and unload mechanism
> with and without the video devices being in use. And it was
> handled all very well.
>
> Great job, thanks!
