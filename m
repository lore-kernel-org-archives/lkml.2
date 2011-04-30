Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab1D3QIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 12:08:13 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:51889 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752778Ab1D3QII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 12:08:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=sedN8W3es18jHCtz3J7Tel6pexxeexBL6zrphluT1S4frW4x/3ixcxBI8VpwoVoBt44NdzwinSMTNBpTjJ5eGjuSqXLh56lbtcqbvkcf7cqXCXBnSzaoIjg287hp0jrm;
Date: Sat, 30 Apr 2011 09:08:05 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, Willy Tarreau <w@1wt.eu>,
        seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9?= Commowick <hcommowick@exosec.fr>,
        linux-kernel mlist <linux-kernel@vger.kernel.org>,
        linux-stable mlist <stable@kernel.org>
Subject: Re: [stable] 2.6.32.21 - uptime related crashes?
Message-Id: <20110430090805.354484ad.rdunlap@xenotime.net>
In-Reply-To: <20110430155707.GA22021@kroah.com>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	<20110428183434.GG30645@1wt.eu>
	<20110429100200.GB23293@pcnci.linuxbox.cz>
	<20110430093605.GA10529@1wt.eu>
	<20110430120205.GA2459@nik-comp.lan>
	<20110430155707.GA22021@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Apr 2011 08:57:07 -0700 Greg KH wrote:

> On Sat, Apr 30, 2011 at 02:02:05PM +0200, Nikola Ciprich wrote:
> > > There was a kernel parameter in the past that was used to make jiffies wrap
> > > a few minutes after boot, maybe we should revive it to try to reproduce
> > > without waiting 7 new months :-/
> > hmm, I've googled this up, and it seems to have been 2.5.x patch, so it will
> > certainly need some porting..
> > I'll try to have a look on it tonight and report...
> 
> I don't think any patch is needed, I thought we did that by default now,
> but I can't seem to find the code where it happens...
> 
> odd.

linux/jiffies.h:

/*
 * Have the 32 bit jiffies value wrap 5 minutes after boot
 * so jiffies wrap bugs show up earlier.
 */
#define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))


and kernel/timer.c:

u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
