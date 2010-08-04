Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758420Ab0HDHGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:06:55 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:56860 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab0HDHGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:06:54 -0400
Date: Wed, 4 Aug 2010 16:06:48 +0900
From: Simon Horman <horms@verge.net.au>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Neuling <mikey@neuling.org>
Subject: [rfc] Merge kexec-tools into the kernel tree
Message-ID: <20100804070647.GB24064@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After all the excitement of relocating kexec-tools from
one location on kernel.org to another last week it was
suggested to me by Michael Neuling that the merging
kexec-tools into the kernel tree would be a good idea.

Given that there have been a bunch of issues with kexec
on power that this would resolve. and there is precedence
for tools in the kernel tree, this sounds entirely reasonable to me.
So with my kexec-tools maintainer hat on, I would like to start
a conversation about this.

In order to move the conversation along I have prepared a tree -
a recent clone of Linus's tree + kexec tools.

http://git.kernel.org/?p=linux/kernel/git/horms/kexec-tools-in-kernel-tree.git

I think that a good next step would be to get this tree into linux-next.
And then if all goes well, as Linus to pull the change some time in the future.





For reference the steps taken to make the tree above were roughly as follows.
Thanks to Michael for assistance with this.

git clone
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git clone git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git

cd linux-2.6

git remote add -f kexec ../kexec-tools
git merge -s ours --no-commit kexec/master
git read-tree --prefix=tools/kexec/ -u kexec/master
git commit -m "Merge kexec-tools into subdirectory tools/kexec"

