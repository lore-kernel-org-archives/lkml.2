Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab0FIGzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 02:55:42 -0400
Received: from smtp-out.google.com ([74.125.121.35]:33212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0FIGzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 02:55:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=ZYgCpb/vs3TWcRQwA5BUudyHjVftxuPXlYR3vnIOr1jAVgjSJtVm1cmtPyEHQH6Pp
	1eDFj6Yi1uI50F5yXSXSA==
Date: Tue, 8 Jun 2010 23:55:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Boaz Harrosh <bharrosh@panasas.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Frans Pop <elendil@planet.nl>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kbuild: Fix the breakage caused by "improve version string
 logic"
In-Reply-To: <4C0E17F0.5010902@panasas.com>
Message-ID: <alpine.DEB.2.00.1006082352120.30606@chino.kir.corp.google.com>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
 <20091006173508.GA4786@elte.hu> <20091012195733.GA7351@elte.hu> <4C0D29DE.6050602@panasas.com> <alpine.DEB.2.00.1006071242510.30389@chino.kir.corp.google.com> <4C0DFFFF.1010704@panasas.com> <alpine.DEB.2.00.1006080200190.18052@chino.kir.corp.google.com>
 <4C0E17F0.5010902@panasas.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jun 2010, Boaz Harrosh wrote:

> What is a tagged commit:
> 
> [my_tree] $ git branch
> *master
> [my_tree] $ git tag v2.6.35-rc2-my-tree
> [my_tree] $ cat localversion-my-tree
> -my-tree
> 
> I still get: DEPMOD 2.6.35-rc2-my-tree+
> 
> How to solve? please specify.
> 

You need to use git tag -a.

> In my tree there is 2.6.35-rc2-my-tree so it cannot be mistaken with
> Linus tree.
> 

Just because you have appended "-my-tree" to the version string does not 
mean it is not vanilla 2.6.35-rc2.  You could append information such as 
that just for a different config, for instance.  The `+' modifies the base 
kernel version (2.6.35-rc2), not the string itself or whatever you choose 
to add to it.

> > As mentioned previously, you can easily suppress that from being added by 
> > using "make LOCALVERSION=-foo" to create a 2.6.35-rc2-foo kernel when you 
> > do not have CONFIG_LOCALVERSION_AUTO enabled.  You already found that you 
> > cannot pass an empty LOCALVERSION string, so it must be something to 
> > identify itself as unique from vanilla 2.6.35-rc2.
> > 
> 
> As mentioned previously this is not an option I do not have git control
> over how this gets compiled.
> 

If your git repository is publically accessible, it is very simple to tag 
commits that you want your users to pull from to indicate it's a 
"release".  That allows you to determine whether other users have extra 
commits on top of your release when they send you bug reports, for 
example, which is quite helpful.
