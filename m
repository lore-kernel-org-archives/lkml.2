Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0HAGO0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:14:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60494 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab0HAGOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OBWhzp5FPqGn6LaGLlhMiPkyjvVRDKi4JVZkzsTb2EoBY7ARS60b9LOPh2+RcG2Jjr
         U1rxhOmlvGDj1hiMnJlvux/R114e8KLIhtXC2oKv/fh/eRU5yQv8lP7jykO3EAzam7O8
         qhZ+/fcjwOxwfnylzhZyJ4N7WM/nqSEJJrIEw=
Date: Sun, 1 Aug 2010 10:14:06 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Ungerer <gerg@uclinux.org>, Christoph Egger <siccegge@cs.fau.de>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] 68328serial: check return value of copy_*_user()
 instead of access_ok()
Message-ID: <20100801061230.GA2650@albatros>
References: <1280597881-8365-1-git-send-email-segooon@gmail.com>
 <20100731190907.GE26313@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100731190907.GE26313@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 31, 2010 at 21:09 +0200, Dan Carpenter wrote:
> On Sat, Jul 31, 2010 at 09:38:00PM +0400, Kulikov Vasiliy wrote:
> > -						sizeof(struct m68k_serial)))
> > -				return -EFAULT;
> > -			copy_to_user((struct m68k_serial *) arg,
> > +			return copy_to_user((struct m68k_serial *) arg,
> >  				    info, sizeof(struct m68k_serial));
> 
> We should return if -EFAULT copy_to_user() failes here.

Right, I was looking for this bug and made it myself :)
Thank you.

> 
> > -			return 0;
> > -			
> >  		default:
> >  			return -ENOIOCTLCMD;
> >  		}
> 
> Smatch would have caught that but I don't have a cross compile
> environment set up.
> 
> regards,
> dan carpenter
