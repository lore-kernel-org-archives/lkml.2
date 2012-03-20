Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab2CTNDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:03:32 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:40481 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab2CTNDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:03:31 -0400
Date: Tue, 20 Mar 2012 09:03:25 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: David Miller <davem@davemloft.net>
Cc: Valdis.Kletnieks@vt.edu, joe@perches.com, anca.emanuel@gmail.com,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ext4: Use pr_fmt and pr_<level>
Message-ID: <20120320130325.GG14363@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, Valdis.Kletnieks@vt.edu,
	joe@perches.com, anca.emanuel@gmail.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120320025835.GE14363@thunk.org>
 <1332212574.7847.49.camel@joe2Laptop>
 <216818.1332222366@turing-police.cc.vt.edu>
 <20120320.031001.1532841232287663716.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320.031001.1532841232287663716.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 03:10:01AM -0400, David Miller wrote:
> > OK. Say I'm a scraper.  How do I distinguish between:
> > 
> > pr_info("foo");
> > printk(KERN_INFO "foo");
> > 
> > Oh my. seems that both result in exactly the same thing ending up in the
> > dmesg buffer
> 
> No it doesn't result in the same output, read the definitions again.
> 
> pr_info can be influenced by pr_fmt, plain printk cannot

But if you don't use pr_fmt, it's the same.  And even if you do, then
pr_info() is the same as printk(KERN_INFO pr_fmt ...).  For a device
driver where cut and paste reuse happens, sure, it's handy.  But for
the rest of the kernel, it doesn't really buy you anything.  

And as I've said, something like ext4_msg(sb, ...) is **far** more
useful.  I don't need a 1200-line patch that messes with debug
printk's that are #ifdef'ed out.

     	   	     	  	       	       - Ted
