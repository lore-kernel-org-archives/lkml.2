Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761365Ab2KALUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:20:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab2KALUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:20:00 -0400
Date: Thu, 1 Nov 2012 12:19:57 +0100
From: Jan Kara <jack@suse.cz>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: enabling psacct breaks fsfreeze
Message-ID: <20121101111957.GD6584@quack.suse.cz>
References: <20121023094351.GC27919@pcnci.linuxbox.cz>
 <20121031121517.GD18424@quack.suse.cz>
 <20121031124600.GM20752@pcnci.linuxbox.cz>
 <20121101093723.GC6584@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121101093723.GC6584@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-11-12 10:37:23, Jan Kara wrote:
> On Wed 31-10-12 13:46:00, Nikola Ciprich wrote:
> > Hi Jan,
> > 
> > thanks for the reply, sure, I'll gather and post requested info.
> > One more note before that, the problem is with psacct, not audit
> >  - psacct if I'm not mistaken  (and as opposed to audit) doesn't
> > use any userspace, kernel dumps information directly to fs, 
> > which might the reason for deadlock..
>   Ah, right. Now I looked into the right code and I can see what's the
> problem. I'll see what we could do about that... So far I don't have a
> better idea than just dropping accounting records that should be written to
> frozen filesystem (as you have nowhere to write those records to).
  But I'd still be interested in those traces. I can see how one process
gets blocked but it's not quite clear on which locks do other block.

								Honza

> > > > Should more debugging information be needed, I'll be glad to provide whatever I can..
> > >   Thanks for report. Hum, I'm not sure how the deadlock can happen because
> > > AFAIU audit sends a message via netlink to userspace and whatever audit
> > > daemon does with it is its private thing. Can you please run:
> > >   echo w >/proc/sysrq-trigger
> > > after the machine deadlocks and then take dmesg and attach it here? You'll
> > > have to have the shell prepared and use serial console / netconsole to gather
> > > dmesg or try your luck with copying via ssh / netcat.
> > > 
> > > 								Honza
> > > -- 
> > > Jan Kara <jack@suse.cz>
> > > SUSE Labs, CR
> > > 
> > 
> > -- 
> > -------------------------------------
> > Ing. Nikola CIPRICH
> > LinuxBox.cz, s.r.o.
> > 28.rijna 168, 709 00 Ostrava
> > 
> > tel.:   +420 591 166 214
> > fax:    +420 596 621 273
> > mobil:  +420 777 093 799
> > www.linuxbox.cz
> > 
> > mobil servis: +420 737 238 656
> > email servis: servis@linuxbox.cz
> > -------------------------------------
> 
> 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
