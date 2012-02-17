Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2BQT3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:29:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60828 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab2BQT3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:29:05 -0500
Date: Fri, 17 Feb 2012 20:28:59 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tejun Heo <tj@kernel.org>
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>, netdev@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, David Fries <david@fries.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] hiberante hangs TCP Re: [EXAMPLE CODE] Parasite
 thread injection and TCP connection hijacking
Message-ID: <20120217192859.GG2707@elf.ucw.cz>
References: <20110806121247.GC23937@htj.dyndns.org>
 <20111030044821.GA23741@spacedout.fries.net>
 <20111030201618.GA7696@google.com>
 <CAJ0PZbSRX6Rqn5NnnMkVGrPovtSuc2NWasysOYnjr3j9rON1VQ@mail.gmail.com>
 <20111102151039.GA12543@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111102151039.GA12543@dhcp-172-17-108-109.mtv.corp.google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-11-02 08:10:39, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 02, 2011 at 06:44:31PM +0900, MyungJoo Ham wrote:
> > > Hmmm... sounds like taking down network interfaces before starting
> > > hibernation sequence should be enough, which shouldn't be too
> > > difficult to implement from userland.  Rafael, what do you think?
> > >
> > > Thanks.
> > 
> > Um... it seems that the "thaw" callbacks of network interfaces or TCP
> > should do something on this.
> > 
> > Probably, the "thaw" callbacks should make sure that the TCP
> > connections are closed?
> 
> I don't think it's a good idea to diddle with TCP connections from
> that layer.  From what I understand, it seem all we need is plugging
> tx/rx while preparing for hibernation.  That shouldn't be too
> difficult.

Yes, that should be done. 

If someone has uswsusp setup where they talk over the network, it
might break them, but hopefully noone is doing that.

Also hopefully noone does hibernation on /dev/nbd.

      	    							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
