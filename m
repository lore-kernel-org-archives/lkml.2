Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab0IMT0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:26:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:55841 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab0IMT0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:26:31 -0400
From: Thomas Renninger <trenn@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: build warning after merge of the final tree (driver-core tree related)
Date: Mon, 13 Sep 2010 21:26:13 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34.4-0.1.99.9.f8e4270-desktop; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Baron <jbaron@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20100907115426.fc0c3e13.sfr@canb.auug.org.au> <20100907023404.GA11972@kroah.com> <20100913085155.6b73c9cc.randy.dunlap@oracle.com>
In-Reply-To: <20100913085155.6b73c9cc.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009132126.14115.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 September 2010 17:51:55 Randy Dunlap wrote:
> On Mon, 6 Sep 2010 19:34:04 -0700 Greg KH wrote:
> 
> > On Tue, Sep 07, 2010 at 11:54:26AM +1000, Stephen Rothwell wrote:
> > > Hi Greg,
> > > 
> > > After merging the final tree, today's linux-next build (powerpc
> > > allnoconfig) produced this warning:
> > > 
> > > kernel/params.c: In function 'parse_args':
> > > kernel/params.c:233: warning: the frame size of 1032 bytes is larger than 1024 bytes
> > > 
> > > Introduced by commit 32e6407e9361cd1aac39ff6b744cad48d1802a08 ("Dynamic
> > > Debug: Introduce global fake module param module.ddebug") which added a
> > > 1024 byte array to the stack ...
> > 
> > Wierd, why didn't this show up yesterday?  The patch was in that tree
> > then, right?
> > 
> > Thomas, care to fix this up?
>  
> ping.  Is Thomas around??
Yep, sorry for not responding.

I tried to reproduce this on ppc64, but above file compiled without
warning with dynamic debug set. Thus I thought this still came from the
old patch.

I have another solution for that, please drop above patch.
Jason pointed out that kernel boot params for compiled-in modules are
not recognized correctly. I fiddled with that for quite some time last week...

I should be able to send something tomorrow.
I will include lkml as it touches several files, would be great if Greg
can pick them up again if feedback is positive.

Thanks,

    Thomas
