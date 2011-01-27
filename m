Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1A0TyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:54:00 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52652 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753256Ab1A0Tx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:53:59 -0500
Date: Thu, 27 Jan 2011 14:53:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Davidlohr Bueso <dave@gnu.org>
cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: ffs-test: fix header path
In-Reply-To: <1296157168.2113.5.camel@offworld>
Message-ID: <Pine.LNX.4.44L0.1101271451570.2090-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Davidlohr Bueso wrote:

> From: Davidlohr Bueso <dave@gnu.org>
> 
> When compiling this program the functionfs.h header cannot be found, producing:
> ffs-test.c:40: fatal error: linux/usb/functionfs.h: No such file or directory
> 
> This patch also fixes the following warning:
> ffs-test.c:453: warning: format ‘%4d’ expects type ‘int’, but argument 3 has type ‘size_t’

> @@ -450,7 +450,7 @@ invalid:
>  		    len, expected, *p);
>  		for (p = buf, len = 0; len < nbytes; ++p, ++len) {
>  			if (0 == (len % 32))
> -				fprintf(stderr, "%4d:", len);
> +				fprintf(stderr, "%4ld:", len);

Since len's type is size_t, shouldn't the format be %4z?

Alan Stern

