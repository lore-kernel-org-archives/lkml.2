Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab2J2WfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:35:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58347 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab2J2WfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 18:35:06 -0400
Date: Mon, 29 Oct 2012 18:35:03 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.6.0 ext4 dump/filemap_fault?
Message-ID: <20121029223503.GA9532@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org
References: <015201cdb54f$844487e0$8ccd97a0$@lucidpixels.com>
 <20121028225109.GA6931@thunk.org>
 <CAO9zADx=DHHDcj3by9RSMatN4RFOQLzWwPJCZzs=NemQ4_sOUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9zADx=DHHDcj3by9RSMatN4RFOQLzWwPJCZzs=NemQ4_sOUQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 05:51:37PM -0400, Justin Piszcz wrote:
> 
> > What happened afterwards?
> It did eventually complete.
> 
> > How much memory do you have in your system?
> 32GB memory/32GB swap
> > Did the system continue, and did the sync command (I presume you ran
> > "sync" from the command line?)  finally return to the command prompt?
> In this case I did not run sync, I waited for the processes/dump/etc
> to complete.

OK, well *some* process must have issued a sync system call, since
that was what triggered the soft lockup.  If half your memory was
dirtied, then the time it might take to write back 16 gigs would
roughly:
 
   (16 GB * 1024 MB/G) /  100 MB/s = 163 seconds

... which would be enough to trigger the soft lockup error.

    	  	   	     	     	      - Ted


