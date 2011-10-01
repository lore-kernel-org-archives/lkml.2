Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab1JAVXa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:23:30 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:54739 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751007Ab1JAVXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:23:25 -0400
X-Sasl-enc: RdjCLi8E+G69xevr+SvWhlgbEgxOozJ6EOmcCE7gF0F8 1317504204
Date: Sat, 1 Oct 2011 18:23:21 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Willy Tarreau <w@1wt.eu>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Miller <davem@davemloft.net>,
        greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111001212321.GE23355@khazad-dum.debian.net>
References: <20110930235924.GA25176@kroah.com>
 <20111001073533.GA18690@1wt.eu>
 <20111001180641.GD6309@home.goodmis.org>
 <20111001.141343.2293070262147973147.davem@davemloft.net>
 <1317493763.4588.70.camel@gandalf.stny.rr.com>
 <20111001183448.GD18690@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111001183448.GD18690@1wt.eu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Oct 2011, Willy Tarreau wrote:
> > > I haven't allowed sshd to run on port 22 in more than 10 years.
> > 
> > I use to do that a long time ago, but I ran into issues because of it.

...

> 443 is pretty nice for connecting from unexpected places ;-)

The better IPS/IDS-protected corporate networks are likely to get annoyed by
SSH signatures showing up on unexpected flows.  Such networks typically will
also object to non-SSL flows of any sort over port 443.

YMMV.

> > I probably can go back to a non 22 port without much issue. I have added
> > a bunch of personal checks to this box that gives a report every day. I
> > may add more (from what was posted in this thread already). I also have
> > logwatch and rkhunter running, and just added chkrootkit now.
> > 
> > But moving the ssh port again may be a good idea. But I like stressing
> > your net filtering code ;)
> 
> BTW ipset is particularly suited for this.

And fail2ban is a ready-made solution to firewall anything that is loitering
around.  It is quite popular, so it is likely already packaged by the
distro.

There is no reason to move SSH from port 22, it is just plain safer to use
port-knocking if you want it unreachable most of the time.  You should also
avoid password-guessing attacks entirely (some botnets can do distributed
low-speed password guessing attacks, I've seen it happen at work) by always
requiring pubkey auth as one of the credentials.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
