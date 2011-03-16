Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1CPVPt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:15:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48137 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab1CPVPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:15:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=mGNHH+SojX60gGRadKawZ7dfJ0FcnfLSTjj3J8K6vrhhQ9rFuFT5W7+1IEnyKBk3e2
         EGEbheQfjcWb/RPPo0nlhiiiRrzyxRvA3ut3iDggVhcbZVJMOmgmCEkewwUqYJWqCNFQ
         ojgYHVAqfKXBUlhyioOrC9/1tm11a4PKL4HME=
Date: Wed, 16 Mar 2011 23:15:25 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        serge@hallyn.com, eparis@redhat.com, jmorris@namei.org,
        eugeneteo@kernel.org, drosenberg@vsecurity.com,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Message-ID: <20110316211525.GA13711@p183.telecom.by>
References: <1300303907-22627-1-git-send-email-richard@nod.at>
 <201103162152.49615.richard@nod.at>
 <20110316210452.GA13624@p183.telecom.by>
 <201103162207.49182.richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201103162207.49182.richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 10:07:48PM +0100, Richard Weinberger wrote:
> Am Mittwoch 16 März 2011, 22:04:52 schrieb Alexey Dobriyan:
> > On Wed, Mar 16, 2011 at 09:52:49PM +0100, Richard Weinberger wrote:
> > > Am Mittwoch 16 März 2011, 21:45:45 schrieb Arnd Bergmann:
> > > > On Wednesday 16 March 2011 21:08:16 Richard Weinberger wrote:
> > > > > Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
> > > > > > On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
> > > > > > > When containers like LXC are used a unprivileged and jailed
> > > > > > > root user can still write to critical files in /proc/.
> > > > > > > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
> > > > > > > 
> > > > > > > This new restricted attribute makes it possible to protect such
> > > > > > > files. When restricted is set to true root needs CAP_SYS_ADMIN
> > > > > > > to into the file.
> > > > > > 
> > > > > > I was thinking about this too. I'd prefer more fine-grained control
> > > > > > in this area, since some sysctl entries aren't strictly controlled
> > > > > > by CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking
> > > > > > CAP_SYS_RAWIO).
> > > > > > 
> > > > > > How about this instead?
> > > > > 
> > > > > Good Idea.
> > > > > May we should also consider a per-directory restriction.
> > > > > Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
> > > > > It would be much easier to set the protection on the parent directory
> > > > > instead of protecting file by file...
> > > > 
> > > > How does this interact with the per-namespace sysctls that Eric
> > > > Biederman added a few years ago?
> > > 
> > > Do you mean CONFIG_{UTS, UPC, USER, NET,}_NS?
> > 
> > It only covers /proc/sys/net/
> 
> Exactly.
> 
> > > > I had expected that any dangerous sysctl would not be visible in
> > > > an unpriviledge container anyway.
> > > 
> > > No way.
> > 
> > No way what exactly?
> 
> Dangerous sysctls are not protected at all.
> E.g. A jailed root can use /proc/sysrq-trigger.

Yes, and it's suggested that you do not show it at all,
instead of bloaing ctl_table.

But this requires knowledge which /proc is root and which one is "root".
:-(

With current splitup into FOO_NS...
