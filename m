Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab0LNUMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 15:12:46 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:46600 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759882Ab0LNUMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 15:12:45 -0500
Date: Tue, 14 Dec 2010 13:12:43 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Matt Domsch <Matt_Domsch@Dell.com>
Cc: Narendra_K@Dell.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Jordan_Hargrave@Dell.com,
        Charles_Rose@Dell.com
Subject: Re: [PATCH] Enable pci=bfsort by default on future Dell systems
Message-ID: <20101214201242.GC21909@parisc-linux.org>
References: <20101214175048.GC31345@fedora-14-r710.oslab.blr.amer.dell.com> <20101214195445.GA31714@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214195445.GA31714@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 01:54:45PM -0600, Matt Domsch wrote:
> You may be asking "why is this necessary with the biosdevname work
> going on?".  Short story is, yes, biosdevname continues to be the
> medium-term strategy, and we are addressing as much as we can in that,
> getting into all the distributions future releases, adding it in the
> distro installer environments.  However, biosdevname adoption has been
> slow (I started writing it 5 years ago), and there's a good chance it
> won't be picked up by all older distribution releases in Service
> Packs, Updates, or the like.  By continuing to use the pci=bfsort
> workaround, we can more likely get this small patch into older
> distribution update relesaes where we are already doing hardware
> enablement, as it can only affect future Dell servers, no impact to
> existing systems or installations.  It also gives flexibility to
> current kernels and distribution releases on when they pick up
> biosdevname.  The two (pci=bfsort and biosdevname) do not conflict in
> any way.

Actually, how about we introduce a smaller patch that just makes
bfsort the default for all machines with a BIOS date of 2011 or later?
bfsort was what we always intended; it was unintentionally broken for,
what, five years, and the only reason not to revert it was to not break
setups that had come to rely on it.

So just make it the default for all future systems, no matter what
manufacturer.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
