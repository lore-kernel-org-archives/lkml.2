Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1ART5W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 14:57:22 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51279 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab1ART5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 14:57:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vFNrs/htWprrLAs42PkD6481Zd8qUcoIQ+FbUa7fsNZc6zMHal51RTmEvl8bqq7e3V
         jlGUUUMyTGAVH1/3uNlbRcNqEXs/3bYs6VMhwV0fhIKipdit4WyUGOZ120MThTDSIyqQ
         042A6O0wU+7eh7RR5aAjy8VZkL2SD758ydxxA=
Date: Tue, 18 Jan 2011 11:57:11 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Engraf <david.engraf@sysgo.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serio: allow registered drivers to get status flag
Message-ID: <20110118195710.GA27152@core.coreip.homeip.net>
References: <4D358E31.4080700@sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D358E31.4080700@sysgo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 01:57:21PM +0100, David Engraf wrote:
> Parse the status byte information to the registered serio drivers as
> well as the character bytes.
> 
> Signed-off-by: David Engraf <david.engraf@sysgo.com>
> 

> --- linux-2.6.37/drivers/input/serio/serport.c.orig	2011-01-18 12:33:41.421709232 +0100
> +++ linux-2.6.37/drivers/input/serio/serport.c	2011-01-18 13:33:24.521711214 +0100
> @@ -116,8 +116,8 @@ static void serport_ldisc_close(struct t
>  
>  /*
>   * serport_ldisc_receive() is called by the low level tty driver when characters
> - * are ready for us. We forward the characters, one by one to the 'interrupt'
> - * routine.
> + * are ready for us. We forward the characters and flags, one by one to the 
> + * 'interrupt' routine.
>   */
>  
>  static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *cp, char *fp, int count)
> @@ -132,7 +132,7 @@ static void serport_ldisc_receive(struct
>  		goto out;
>  
>  	for (i = 0; i < count; i++)
> -		serio_interrupt(serport->serio, cp[i], 0);
> +		serio_interrupt(serport->serio, cp[i], fp[i]);
>  

Hi David,

The flags argument that serio_interrupt() accepts not the raw protocol
data, but sanitized, protocol-independent SERIO_TIMEOUT, SERIO_PARITY
and SERIO_FRAME bits.

Thanks.

-- 
Dmitry
