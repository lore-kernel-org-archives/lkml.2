Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0JQRuP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 13:50:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:58190 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab0JQRuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 13:50:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mccpiEqwq/APfYx4isBGfjVbH/e8q/ACU+DooxAjFWIp/POS7rxWGVG3c6sYh3nDnh
         gR9V3BWLFnBrxzMX7tKqWMTEpGMRX10gz420re7rMIc2LtbO/zieltYLMIdqWl157Jr8
         O6LFwsY9wAnOqtOMTfAN4eAvIb5QzagtnQrxw=
Date: Sun, 17 Oct 2010 21:50:06 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, Jiri Slaby <jslaby@suse.cz>,
        kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] char: synclink: fix information leak to userland
Message-ID: <20101017175006.GA14278@albatros>
References: <1287326493-8134-1-git-send-email-segooon@gmail.com>
 <4CBB177C.9050007@suse.cz>
 <20101017153839.GA11029@albatros>
 <20101017173609.GS6614@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017173609.GS6614@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 19:36 +0200, Dan Carpenter wrote:
> On Sun, Oct 17, 2010 at 07:38:39PM +0400, Vasiliy Kulikov wrote:
> > On Sun, Oct 17, 2010 at 17:34 +0200, Jiri Slaby wrote:
> > > On 10/17/2010 04:41 PM, Vasiliy Kulikov wrote:
> > > > Structure new_line is copied to userland with some padding fields unitialized.
> > > > It leads to leaking of stack memory.
> > > 
> > > I think your tool has a bug. I must admit I fail to see the padding
> > > which would cause leaks. Could you elaborate?
> > 
> > I didn't use any tool except "grep copy_to_user" :)
> > 
> 
> It seems like you should be able to use pahole to make a list of
> structs with padding and then a checker script to find places where
> information is leaked.

Not all of these patches fix only padding zeroing, some of them fix
uninitialized fields.  One struct has partly initialized array.

> Also someone complained to me about when I added a memset() in a fast
> path.

All these cases are ioctl() handlers or similar.  I don't think ioctl()
should be so fast to become significantly slower with single memset().

> The thought was that it might be faster to just initialize it
> instead like:
> 
> 	struct foo bar = {};
> 
> In my case just using the initializer made the code cleaner so I did it,
> but neither of us actually benchmarked it.
> 
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Thanks,

-- 
Vasiliy
