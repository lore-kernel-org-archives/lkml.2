Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1AUHg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 02:36:56 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35171 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab1AUHgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 02:36:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rpcAkRaKh4FIi8DOpto8klx8j20hl1vQf3qcd7VmD6UT5AqUqPMDNVUv3gHY4w1vLG
         4eOQOHF0AB3SLA6vpQHGyycNzbaOvX1Qm71Rs6gfTc1//pq2gH1VTyfxhU6WCfMZYf8z
         54nlMNlyRhIrQfZpVfoCFyL6UsXLZ38qU/KvY=
Date: Thu, 20 Jan 2011 23:36:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] input: trackpoint: return proper error value
Message-ID: <20110121073605.GC21842@core.coreip.homeip.net>
References: <1295534730.2089.1.camel@offworld>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295534730.2089.1.camel@offworld>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 11:45:30AM -0300, Davidlohr Bueso wrote:
> From: Davidlohr Bueso <dave@gnu.org>
> 
> If sysfs_create_group() returns an error, we should return it in trackpoint_detect(), instead of -1.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  drivers/input/mouse/trackpoint.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
> index 54b2fa8..e8b7c3f 100644
> --- a/drivers/input/mouse/trackpoint.c
> +++ b/drivers/input/mouse/trackpoint.c
> @@ -324,7 +324,7 @@ int trackpoint_detect(struct psmouse *psmouse, bool set_properties)
>  			error);
>  		kfree(psmouse->private);
>  		psmouse->private = NULL;
> -		return -1;
> +		return error;

This is not the only place where we return -1 in place of proper error
code in that driver. Care to update all of them?

Thanks.

-- 
Dmitry
