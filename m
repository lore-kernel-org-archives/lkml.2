Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0JQRgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 13:36:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53224 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab0JQRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 13:36:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=RZoo2rrP+nLSI14Hwg5a0wZon/JOyxFe9vmaUPf241cZb+otIMgnwM6dMx1wXM70Pi
         4JRFGxiqLGt77+WN+bnpXLP25Jd27112yUR/Q4NbPMgA7LEBI6/YkyXbrqnIgpxW7W9L
         yUpJ/J8EE57vbWe4ROLdmlWm0czvWbnJuY1MI=
Date: Sun, 17 Oct 2010 19:36:09 +0200
From: Dan Carpenter <error27@gmail.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] char: synclink: fix information leak to userland
Message-ID: <20101017173609.GS6614@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Vasiliy Kulikov <segooon@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
	kernel-janitors@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org
References: <1287326493-8134-1-git-send-email-segooon@gmail.com> <4CBB177C.9050007@suse.cz> <20101017153839.GA11029@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017153839.GA11029@albatros>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 07:38:39PM +0400, Vasiliy Kulikov wrote:
> On Sun, Oct 17, 2010 at 17:34 +0200, Jiri Slaby wrote:
> > On 10/17/2010 04:41 PM, Vasiliy Kulikov wrote:
> > > Structure new_line is copied to userland with some padding fields unitialized.
> > > It leads to leaking of stack memory.
> > 
> > I think your tool has a bug. I must admit I fail to see the padding
> > which would cause leaks. Could you elaborate?
> 
> I didn't use any tool except "grep copy_to_user" :)
> 

It seems like you should be able to use pahole to make a list of
structs with padding and then a checker script to find places where
information is leaked.

Also someone complained to me about when I added a memset() in a fast
path.  The thought was that it might be faster to just initialize it
instead like:

	struct foo bar = {};

In my case just using the initializer made the code cleaner so I did it,
but neither of us actually benchmarked it.

regards,
dan carpenter
