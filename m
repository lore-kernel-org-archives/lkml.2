Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab1HPNZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:25:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58819 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab1HPNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:25:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Aug 2011 15:24:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Pavel Roskin <proski@gnu.org>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: Suppressing a plus from setlocalversion
Message-ID: <20110816152458.71b0bd74@stein>
In-Reply-To: <20110815222141.jgw2q59rko0wssoc-cebfxv@webmail.spamcop.net>
References: <20110815173706.12ccfdd4@mj>
	<alpine.DEB.2.00.1108151600400.22798@chino.kir.corp.google.com>
	<20110815222141.jgw2q59rko0wssoc-cebfxv@webmail.spamcop.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15 Pavel Roskin wrote:
> Quoting David Rientjes <rientjes@google.com>:
> 
> > On Mon, 15 Aug 2011, Pavel Roskin wrote:
> >
> >> Hello!
> >>
> >> There is one annoyance in the build system that I cannot work around.
> >
> > That's surprising since you actually state the workaround, i.e. using
> > LOCALVERSION= with make, yourself.
> 
> OK, I don't consider that an acceptable solution, as it could  
> interfere with other build systems.
> 
> However, as soon as I posted this message, I found a better solution,  
> namely setting LOCALVERSION= in the environment (both for the normal  
> user and for root).  This is less likely to have unexpected effects,  
> since the environment variables don't override the variables  
> explicitly set in makefiles.

Having this globally as an environment variable seems to be a more
intrusive alternative; there are no namespaces.

You can wrap the make command lines that you often use into shell
aliases.  I often use command lines like 'nice make -j8' or
'nice make -j8 C=1 CF="-D__CHECK_ENDIAN__"' by alias.

> > Yes, because the kernel you've produced is no longer 3.1.0-rc2, it is
> > modified.  If you want to do something else locally, then you can always
> > use LOCALVERSION=.
> >
> > The + was added to stop falsely identifying kernels as a specific version
> > when they are modified by default.  Sorry if you forget to override it
> > sometimes.

I for one am glad that I don't have to remember to force a localversion
all the time.  All of the kernels that I runtime-test have their source
managed by quilt, not git.  Thankfully, scripts/setlocalversion
acknowledges that quilt users know what they are doing. :-)
-- 
Stefan Richter
-=====-==-== =--- =----
http://arcgraph.de/sr/
