Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab0LBEvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 23:51:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33853 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab0LBEvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 23:51:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=c35fHa57hsFzJhUyKKJS3Kk2sR8eUmg490pgjH8WDq48R0gjBOYgeTEWeTi6LNElQy
         qxXQvvtwQRGH2PD4Y1omvVOhG8MkuB+4HQLf3rKmSR/uoUUKbJXATQzlA8Gpe8d1sVe7
         4U8ajAgIkW9ZWBd6R+Z4Ai9yc+ZXRLw1gUukc=
Date: Thu, 2 Dec 2010 07:51:26 +0300
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
        Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: rc: ir-lirc-codec: fix potential integer
 overflow
Message-ID: <20101202045126.GA1784@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segoon@openwall.com>,
	kernel-janitors@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 08:06:35PM +0300, Vasiliy Kulikov wrote:
>  	count = n / sizeof(int);
> -	if (count > LIRCBUF_SIZE || count % 2 == 0)
> +	if (count > LIRCBUF_SIZE || count % 2 == 0 || n % sizeof(int) != 0)
                                                      ^^^^^^^^^^^^^^^^^^^^

Wait, what?  We just checked this a couple lines before.

The rest of the patch is right and a clever catch.  It would affect 
x86_64 systems and not i386.  This doesn't have security implications
does it?  You'd just catch the kmalloc() stack trace for insanely large
allocations.

regards,
dan carpenter

