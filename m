Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab2FXJkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 05:40:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46780 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2FXJke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 05:40:34 -0400
Message-ID: <1340530947.4696.3.camel@localhost>
Subject: Re: [PATCH] grvga: Fix error handling issues
From: Emil Goode <emilgoode@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Sun, 24 Jun 2012 11:42:27 +0200
In-Reply-To: <20120623223319.GG5333@mwanda>
References: <1340381479-6371-1-git-send-email-emilgoode@gmail.com>
	 <20120623223319.GG5333@mwanda>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is for the sparc architecture and the iounmap doesn't check
for NULL directly as in the x86 version. I think it is safer not to pass
NULL to the sparc version.

Thanks,

Emil
On Sun, 2012-06-24 at 01:33 +0300, Dan Carpenter wrote:
> On Fri, Jun 22, 2012 at 06:11:19PM +0200, Emil Goode wrote:
> > This patch fixes two problems with the error handling in the
> > grvga_probe function.
> > 
> > - If the call to grvga_parse_custom on line 370 fails we use
> >   the wrong label so that release_mem_region will be called
> >   without a call to request_mem_region being made.
> > 
> > - If the call to ioremap on line 436 fails we should not try
> >   to call iounmap. I added an if statement to check whether or
> >   not a call to iounmap should be made.
> > 
> 
> Doesn't iounmap() have a check for NULL?  On x86 it does.
> 
> 	if ((void __force *)addr <= high_memory)
> 		return;
> 
> regards,
> dan carpenter
> 
> 


