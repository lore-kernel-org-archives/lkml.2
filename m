Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2ITWqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:46:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56831 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756436Ab2ITWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:46:09 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 20 Sep 2012 15:45:46 -0700
X-Google-Sender-Auth: jo8m784EiNJFx1gTW3wojRRGkWo
Message-ID: <CAB=NE6UVZ2HQU27LdkzUFe3of6N1v8YZYVMKsfA+0Wmg5nRBug@mail.gmail.com>
Subject: Helping with backports: linux-next, linux, linux-stable - a few enhancements
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Konstantin Ryabitsev <mricon@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, backports@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg, Stephen, Konstantin,

so for the Linux backports project [0] we rely on a few git trees:

  * linux-next.git
  * linux-stable.git
  * linux.git

The linux.git tree is required for RC releases. The linux-stable.git
tree for extraversion stable releases, and the linux-next.git tree for
daily snapshots. There is a trick for stable releases whereby we
accelerate the integration of pending-stable patches by cherry picking
them out of linux-next.git if the commit log entry has the
'stable@vger.kernel.org' on the commit log, and if the stable patch
does not apply we require the developers to provide a backport
compatible port. This trick works swell on linux-next.git for RC
release given that we can query for rc releases there as linux-next
carries them but linux-next.git does not carry extra version tags.
Additionally the requirement of linux.git is only there given that at
times there are delays between which linux-stable.git will not have an
RC release on it. I have a way to address all these issues, namely to
add linux.git as a remote for my local linux-stable tree, and also by
adding linux-stable as a local remote for my linux-next tree. Now, I
document how I resolve this for backport package consumers / builders
but it occurs to me perhaps we can simplify this if we had:

  * linux-next - pulling in linux-stable packs / tags
  * a new linux-releases.git - which has both linux.git and
linux-stable pulled together through a cronjob

Would this be reasonable to accommodate to help ease of use or shall
we just live with folks having to do the remote / local remote hacks?

[0] https://backports.wiki.kernel.org/

  LUis
