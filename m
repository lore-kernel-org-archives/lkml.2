Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab0DRUNw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 16:13:52 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:43651 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab0DRUNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 16:13:50 -0400
Subject: Re: 2.6.34rc4 NFS writeback regression (bisected): client often
 fails to delete things it just created
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
In-Reply-To: <87mxx0a5pc.fsf@spindle.srvr.nix>
References: <87tyr9dfvv.fsf@spindle.srvr.nix>
	 <1271618484.8049.1.camel@localhost.localdomain>
	 <87vdboa7e0.fsf@spindle.srvr.nix>
	 <1271620750.8049.3.camel@localhost.localdomain>
	 <87mxx0a5pc.fsf@spindle.srvr.nix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Apr 2010 16:13:44 -0400
Message-ID: <1271621624.8049.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 3 sum msgs/h 1 total rcpts 66 max rcpts/h 12 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: A5E6533DA78B086518B3EE1AF4A8A14710F18EB8
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 28 max/h 4 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-04-18 at 21:03 +0100, Nix wrote: 
> On 18 Apr 2010, Trond Myklebust said:
> 
> > On Sun, 2010-04-18 at 20:27 +0100, Nix wrote: 
> >> On 18 Apr 2010, Trond Myklebust verbalised:
> >> tip-of-tree includes that commit, and it's still happening for me there.
> >> (Just verified again.)
> >
> > Does a 'sync' clear out the sillyrenamed files?
> 
> Yes.

OK. Next question is how these files are being written. If you 'strace'
the process, do you see ordinary write() calls being used, or is the
file perhaps being written via mmap()?

