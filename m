Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0HAGT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:19:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52767 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab0HAGTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:19:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TlOqoO1DfGWsglqLtrEOHVEo7/8en2Oyx2+aBMcQtN/rjQahGytMZ0rnDXYhX5wIPn
         oGYdkhccWQfTHEOBSd5gFI6jYfCqRz28xeLtUniQu564QKN95QfrDZT73nLWf1ySOXHu
         hxXdy9pLyqY1oQI/QYYt6h6XFwsbvDjkq/cNU=
Date: Sun, 1 Aug 2010 10:19:34 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Li Yang <leoli@freescale.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>,
        Anton Vorontsov <avorontsov@ru.mvista.com>, linux-usb@vger.kernel.org,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] usb: fsl_udc_core: check return value of
 create_proc_read_entry()
Message-ID: <20100801061934.GB2650@albatros>
References: <1280597900-8405-1-git-send-email-segooon@gmail.com>
 <20100731191743.GF26313@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100731191743.GF26313@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 21:17 +0200, Dan Carpenter wrote:
> On Sat, Jul 31, 2010 at 09:38:20PM +0400, Kulikov Vasiliy wrote:
> > create_proc_read_entry() may fail, if so return -ENOMEM.
> > 
> 
> It can fail, but also we return NULL if procfs is disabled.  I haven't
> looked at it very carefully, would this patch break the module if procfs
> was disabled?
Probably you are right, but many drivers in tree compare return value
with NULL. Some of them interpret this as error, some of them simply
call pr_warn("Hmm, I cannot create file in proc, strange..."). Maybe
there is more simplier way to check it without #ifdefs?

> 
> The same applies to the similar patches in this set.
> 
> regards,
> dan carpenter
> 
> 
