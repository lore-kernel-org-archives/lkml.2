Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0FHJR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 05:17:29 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57043 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab0FHJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 05:17:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=CLdaHVHGRmF7/7qNRnKa5vqNSTk1yg4huGb2berPbxKrdYf2Mpg70XTA/M34GAu7U
	EuLr2nYg72tFA+iZ63xcg==
Date: Tue, 8 Jun 2010 02:17:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, v2] kbuild: Improve version string logic - two for the
 price of one - No thanks
In-Reply-To: <4C0DF6A2.1050608@panasas.com>
Message-ID: <alpine.DEB.2.00.1006080214320.18052@chino.kir.corp.google.com>
References: <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DDAA6.8080002@panasas.com> <alpine.DEB.2.00.1006072311170.31780@chino.kir.corp.google.com>
 <20100608063419.GF6376@linux-sh.org> <4C0DE5AC.1090204@panasas.com> <4C0DEE57.1070505@panasas.com> <4C0DEF92.5000601@panasas.com> <20100608073211.GB13191@linux-sh.org> <4C0DF6A2.1050608@panasas.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Boaz Harrosh wrote:

> And you have broken the "localversion* semantics". Because my vanilla release
> is 2.6.rc2-my_tree-my_ver as checkedout and delivered from my official tree.
> Now you have added a "+" regardless of if it is an official tagged version or
> not.
> 

The `+' modifies the base kernel version, not the version string.  
Otherwise, it would be impossible to determine whether a "2.6.35-rc2-foo" 
kernel were vanilla 2.6.35-rc2 or otherwise modified.

> I do not expect a complicated "let me be smarter than you" system that
> checks any tags of mine and provides an out-of-tree version system. I just
> want a switch that tells the system. "Let me shoot myself in the leg,
> I know what I want"
> 

If you're using git, which you obviously are, then add localversion* files 
to your repository (or modify CONFIG_LOCALVERSION if you pass along your 
.config as well) and use git-tag to indicate its something you're 
releasing as your kernel.
