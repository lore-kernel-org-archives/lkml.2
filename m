Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1AGTuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:50:09 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49002 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1AGTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:50:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TOEvm0wRG+wL0BqzVLFA0UVaHIyXurTjdqY8vD8bKKBjSiIZ6o6qyVNtLX+sPpvHeo
         d/03jMncTtJxAK6Hhc1Hl8hN+hbeN5ACmaIcVScqJst3Hhggzyh2tahs+yCOtwiJuWej
         HQaylM4MX2Qr5gN2aVcEehkVY4j427dNapeeM=
Date: Fri, 7 Jan 2011 11:50:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Trilok Soni <tsoni@codeaurora.org>, Scott Moreau <oreaus@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver (third version)
Message-ID: <20110107195000.GD28875@core.coreip.homeip.net>
References: <4D22ECB6.6090800@armadeus.com>
 <4D22FE0F.7010206@codeaurora.org>
 <4D276CAD.5090604@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D276CAD.5090604@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 08:42:37PM +0100, Fabien Marteau wrote:
> On 04/01/2011 12:01, Trilok Soni wrote:
> > Hi Fabien,
> > 
> > On 1/4/2011 3:17 PM, Fabien Marteau wrote:
> >> +
> >> +static irqreturn_t as5011_int_interrupt(int irq, void *dev_id)
> >> +{
> >> +	struct as5011_platform_data *plat_dat = dev_id;
> >> +
> >> +	mutex_lock(&plat_dat->update_lock);
> >> +	as5011_update_axes(plat_dat);
> >> +	mutex_unlock(&plat_dat->update_lock);
> > 
> > Please explain this lock. Sorry if I have missed out your explanation in the earlier threads.
> 
> If a second interruption occurs the first update must be finished before update again.

The ISR handler will not be called simultaneously on several CPUs. What
else can it race with?

-- 
Dmitry
