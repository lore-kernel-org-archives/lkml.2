Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419Ab2FVL6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 07:58:35 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:2283 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760182Ab2FVL6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 07:58:34 -0400
Message-ID: <1340366312.1773.124.camel@x61.thuisdomein>
Subject: Re: finding unused header files
From: Paul Bolle <pebolle@tiscali.nl>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ysato@users.sourceforge.jp
Date: Fri, 22 Jun 2012 13:58:32 +0200
In-Reply-To: <alpine.DEB.2.02.1206220641150.6493@oneiric>
References: <alpine.DEB.2.02.1206220641150.6493@oneiric>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 22 Jun 2012 11:58:33.0082 (UTC) FILETIME=[58D87DA0:01CD506E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-22 at 06:46 -0400, Robert P. J. Day wrote:
> the script is stupidly conservative and didn't identify that shm.h
> header since *somewhere* in the entire kernel source tree, someone was
> including a file called "shm.h" -- not even for the same architecture.
> like i said, stupidly conservative.

The approach I settled on is, in short, to generate two sets:
I) a set of all header files in the tree;
II) a set of all "paths" used in all the preprocessor include directives
in the tree.
You compare these sets (sort of) backwards, using as little of the paths
in both sets as you can get away with. So sometimes you have a header
"foo.h" and there's not a single include ending in "foo.h": that's an
unused header, and it's easy to spot. But if you do not spot an unused
header that easily, you try whether the long path might also turn up
unused headers, because of mismatches in the earlier parts of the paths
involved. All rather obvious, I guess.

There's a bit more to it - eg, the plain "/asm/" headers generated to
include headers in "/asm-generic/" - but that's the gist of it. Not all
unused headers will be spotted using that approach, but I guess that's a
20/80 rule: 20% of the effort, 80% of the results.

But, whatever approach you take, that's the easy part. The hard part is
peeking at the (history of the) tree to see what happened: was that
header simply never used, did it end up orphaned after changes in other
files, or was it added recently and should we expect a file using that
header to show up in the near future? Figuring all that out turned out
to be time consuming.


Paul Bolle

