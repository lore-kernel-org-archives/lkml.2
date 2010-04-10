Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab0DJATv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 20:19:51 -0400
Received: from tex.lwn.net ([70.33.254.29]:47101 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545Ab0DJATt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 20:19:49 -0400
Date: Fri, 9 Apr 2010 18:19:42 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 08/16] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
Message-ID: <20100409181942.175b375a@bike.lwn.net>
In-Reply-To: <4BBF9EE7.50707@gmx.de>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
	<1270746946-12467-9-git-send-email-corbet@lwn.net>
	<4BBF9EE7.50707@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Apr 2010 23:40:55 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> I don't like the idea of OLPC specific code. Isn't there any way to 
> speed this up in general?

Architecture-specific code happens.  OLPCs are wired differently; if
you go trying to do LVDS out those GPIO ports on an OLPC, you'll not
end up talking to the hardware you think you're talking to.  The best
thing to do is to avoid it altogether.

> There is not yet even an option for OLPC_XO_1_5 (in contrast to 
> CONFIG_OLPC) in mainline. Is such a thing planned?

Yes, it is.  That's part of the remaining OLPC support code which has
also been brought forward to 2.6.34 with the intention of mainlining it.

> I can't really see anything that would speak for accepting this patch 
> now in current mainline, sorry.

If you can come up with a better solution to the problem, I'm all
ears.  But without it you'll have a hard time running mainline kernels
on XO 1.5 systems.  It is all coming, but the OLPC folks are scrambling
to get everything together; I don't think we really need to make things
harder for them.

That said, machine_is_olpc() is properly defined for all
configurations, so the #ifdefs can (and should) come out.

jon
