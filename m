Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab0C3Sec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:34:32 -0400
Received: from mail-pz0-f186.google.com ([209.85.222.186]:52675 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404Ab0C3Sea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:34:30 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 14:34:30 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ROBLnU/njaMMbjDLys9vJKKQ9PuckQS3CbP0ueGqFJH6JprliKgyko4QIwH+1VzJtC
         buf8bo7mhWg3cY+Tq1yLMZQDcvKo3uNDRtO3d/2/FQSKwTysQsBYLMnQDsh9phe6iPNe
         GgWpBjaONKfSV9AzvnCpu2mPq6vQV+RBvCEiA=
Date: Tue, 30 Mar 2010 20:27:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/6] procfs: Push down the bkl from ioctl
Message-ID: <20100330182710.GC5078@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-6-git-send-regression-fweisbec@gmail.com> <201003301237.28083.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003301237.28083.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 11:37:27AM +0100, Arnd Bergmann wrote:
> On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> > Push down the bkl from procfs's ioctl main handler to its users.
> > Only three procfs users implement an ioctl (non unlocked) handler.
> > Turn them into unlocked_ioctl and push down the Devil inside.
> 
> Looks good to me. I would have used a single unlock and return statement
> in i8k_ioctl and isdn_divert_ioctl, with goto instead of adding an
> unlock to each return, but it doesn't matter much.


I did that first, but actually that didn't make much difference:

ret = foo;            unlock_kernel()
goto end;      VS     return foo;




> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>


Thanks.

