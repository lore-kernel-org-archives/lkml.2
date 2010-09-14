Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab0INHW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:22:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0INHWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:22:54 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Greg KH <greg@kroah.com>
Subject: Re: linux-next: build warning after merge of the final tree (driver-core tree related)
Date: Tue, 14 Sep 2010 09:22:51 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jason Baron <jbaron@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20100907115426.fc0c3e13.sfr@canb.auug.org.au> <201009132126.14115.trenn@suse.de> <20100913205712.GB18766@kroah.com>
In-Reply-To: <20100913205712.GB18766@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009140922.51566.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 September 2010 22:57:12 Greg KH wrote:
> On Mon, Sep 13, 2010 at 09:26:13PM +0200, Thomas Renninger wrote:
> > On Monday 13 September 2010 17:51:55 Randy Dunlap wrote:
> > > On Mon, 6 Sep 2010 19:34:04 -0700 Greg KH wrote:
> > > 
> > > > On Tue, Sep 07, 2010 at 11:54:26AM +1000, Stephen Rothwell wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > After merging the final tree, today's linux-next build (powerpc
> > > > > allnoconfig) produced this warning:
> > > > > 
> > > > > kernel/params.c: In function 'parse_args':
> > > > > kernel/params.c:233: warning: the frame size of 1032 bytes is larger than 1024 bytes
> > > > > 
> > > > > Introduced by commit 32e6407e9361cd1aac39ff6b744cad48d1802a08 ("Dynamic
> > > > > Debug: Introduce global fake module param module.ddebug") which added a
> > > > > 1024 byte array to the stack ...
> > > > 
> > > > Wierd, why didn't this show up yesterday?  The patch was in that tree
> > > > then, right?
> > > > 
> > > > Thomas, care to fix this up?
> > >  
> > > ping.  Is Thomas around??
> > Yep, sorry for not responding.
> > 
> > I tried to reproduce this on ppc64, but above file compiled without
> > warning with dynamic debug set. Thus I thought this still came from the
> > old patch.
> > 
> > I have another solution for that, please drop above patch.
> > Jason pointed out that kernel boot params for compiled-in modules are
> > not recognized correctly. I fiddled with that for quite some time last week...
> > 
> > I should be able to send something tomorrow.
> > I will include lkml as it touches several files, would be great if Greg
> > can pick them up again if feedback is positive.
> 
> Ok, which exact patch do you want me to drop, the "Introduce global fake
> module param..." one?
Yes, please.

Thanks,

       Thomas
