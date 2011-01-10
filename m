Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1AJQab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 11:30:31 -0500
Received: from xenotime.net ([72.52.115.56]:54130 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753368Ab1AJQa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 11:30:26 -0500
Date: Mon, 10 Jan 2011 08:30:24 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: christoph.paasch@uclouvain.be
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Ben Hutchings <bhutchings@solarflare.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and
 coding-style
Message-Id: <20110110083024.ab3bad25.rdunlap@xenotime.net>
In-Reply-To: <201101101724.46023.christoph.paasch@uclouvain.be>
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be>
	<201101101244.24932.christoph.paasch@uclouvain.be>
	<20110110075032.e38955ef.rdunlap@xenotime.net>
	<201101101724.46023.christoph.paasch@uclouvain.be>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 17:24:45 +0100 Christoph Paasch wrote:

> 
> On Monday, January 10, 2011 wrote Randy Dunlap:
> > Documentation/SubmitChecklist, #1:
> > 
> > 1: If you use a facility then #include the file that defines/declares
> >    that facility.  Don't depend on other header files pulling in ones
> >    that you use.
> Ok, great. That was the answer I was looking for.
> 
> So, there is a clear rule that defines the #include-policy.
> 
> Now, should the missing #include's be added, or not?
> 
> Alexey Dobriyan is against it, as he says in one of his previous mails.
> And, I'm nearly sure that the rule is not respected in plenty of other files 
> of the Linux Kernel.

If a build fails on any $architecture due to a missing header file, then
the header file should be added.

If you just want to fix source files that are missing header files, then
the patches should be accepted, even if they are not "needed" in some
strong sense of that word.

Adding the header files adds documentation that some interface from that
header file is being used and it prevents failures that would happen
if an indirect #include were removed, so it's a good practice, but sure,
there are plenty of places that miss this.  It was added as Rule #1
(explicity as Rule __#1__) due to so many build errors due to this
that were occurring in linux-next trees.


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
