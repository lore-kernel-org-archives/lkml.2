Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab0KOIPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 03:15:18 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56106 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab0KOIPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 03:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=EinAGZS3tVS44t5Yh4PdV+qhqE4oRPTmrX33X/TtY66i6mN33yFBpYlNU16OngXyKI
         1njqFv8RV5KklG3h44F7dBw9aD7R1VPZa6Gl4Q02uTSM+kuhUTVVxRACy2PYEKiuwtSh
         FB0X1NXSnJujasrePqy3tAb0KKRwZd5ZmD8Hw=
Date: Mon, 15 Nov 2010 11:14:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: walter harms <wharms@bfs.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/2] fbcmap: integer overflow bug
Message-ID: <20101115081457.GC21614@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	walter harms <wharms@bfs.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20101027093716.GD6062@bicker>
 <20101105134018.2c11f283.akpm@linux-foundation.org>
 <20101113100718.GB1795@bicker>
 <20101115044820.GA8489@linux-sh.org>
 <AANLkTin0T5FN6WhUj0csypR=j0UPRbeHN+HC3N9xnk7E@mail.gmail.com>
 <20101115072014.GB21614@bicker>
 <4CE0E8CA.9010704@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE0E8CA.9010704@bfs.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 09:01:14AM +0100, walter harms wrote:
> I do not see the rest of the code but it looks like
> cmap->len is size in int8_t. So the upper limit is something like
> INT_MAX/(sizeof(u16)*2). Perhaps we can call it a char ?
> is there ANY system that has a more than 256 colors in R|G|B ?
> 

Yeah.  There are.  I had a list of some but I've deleted it.

> <spying for struct fb_cmap_user  >
>  __u32 len;
>  __u16 __user *red;
> 
> So no need to check for <0.

I test size which is an int so that's why it's needed.

regards,
dan carpenter

