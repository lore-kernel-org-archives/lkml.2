Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1CPVT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:19:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41007 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab1CPVTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:19:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kSrzGKeeT0rJ4deZ/gwvyOalkDw+hUqsVnU7N2AgSVV0iwVVfhGU9Cx6VYZDa/TQcw
         Yf2FpzuzC8+Uhi2+UfeACo9Os8oBT5vtrUSsbkUDm6EMD29mfw1zkKY0zI/qGMoFD3op
         tBnivJ69v2p1tz+LEQD3mCwcCLRDytGB52j+0=
Date: Wed, 16 Mar 2011 23:19:11 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, serge@hallyn.com, eparis@redhat.com,
        jmorris@namei.org, eugeneteo@kernel.org, drosenberg@vsecurity.com
Subject: Re: [PATCH] [RFC] Make it easier to harden /proc/
Message-ID: <20110316211911.GA13715@p183.telecom.by>
References: <1300303907-22627-1-git-send-email-richard@nod.at>
 <20110316195549.GZ5466@outflux.net>
 <201103162108.17127.richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201103162108.17127.richard@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 09:08:16PM +0100, Richard Weinberger wrote:
> Kees,
> 
> Am Mittwoch 16 März 2011, 20:55:49 schrieb Kees Cook:
> > Hi Richard,
> > 
> > On Wed, Mar 16, 2011 at 08:31:47PM +0100, Richard Weinberger wrote:
> > > When containers like LXC are used a unprivileged and jailed
> > > root user can still write to critical files in /proc/.
> > > E.g: /proc/sys/kernel/{sysrq, panic, panic_on_oops, ... }
> > > 
> > > This new restricted attribute makes it possible to protect such
> > > files. When restricted is set to true root needs CAP_SYS_ADMIN
> > > to into the file.
> > 
> > I was thinking about this too. I'd prefer more fine-grained control
> > in this area, since some sysctl entries aren't strictly controlled by
> > CAP_SYS_ADMIN (e.g. mmap_min_addr is already checking CAP_SYS_RAWIO).
> > 
> > How about this instead?
> 
> Good Idea.
> May we should also consider a per-directory restriction.
> Every file in /proc/sys/{kernel/, vm/, fs/, dev/} needs a protection.
> It would be much easier to set the protection on the parent directory
> instead of protecting file by file...

Of course, not.

You should _enable_ them one by one, not the other way around.

	"default deny"
