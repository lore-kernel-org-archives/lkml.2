Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1K1QLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:11:22 -0500
Received: from mx2.netapp.com ([216.240.18.37]:34966 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab1K1QLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:11:21 -0500
X-IronPort-AV: E=Sophos;i="4.69,584,1315206000"; 
   d="scan'208";a="602753192"
Message-ID: <1322496677.8433.1.camel@lade.trondhjem.org>
Subject: [GIT PULL] Please pull one NFS client bugfix
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 11:11:17 -0500
Organization: NetApp Inc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Mime-Version: 1.0
X-OriginalArrivalTime: 28 Nov 2011 16:11:18.0371 (UTC) FILETIME=[5C8DB330:01CCADE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the "bugfixes" branch of the repository at

   git pull git://git.linux-nfs.org/projects/trondmy/linux-nfs.git bugfixes

This will update the following files through the appended changesets.

  Cheers,
    Trond

----
 net/sunrpc/xprtsock.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

commit 24ca9a847791fd53d9b217330b15f3c285827a18
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Tue Nov 22 14:44:28 2011 +0200

    SUNRPC: Ensure we return EAGAIN in xs_nospace if congestion is cleared
    
    By returning '0' instead of 'EAGAIN' when the tests in xs_nospace() fail
    to find evidence of socket congestion, we are making the RPC engine believe
    that the message was incorrectly sent and so it disconnects the socket
    instead of just retrying.
    
    The bug appears to have been introduced by commit
    5e3771ce2d6a69e10fcc870cdf226d121d868491 (SUNRPC: Ensure that xs_nospace
    return values are propagated).
    
    Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: stable@vger.kernel.org [>= 2.6.30]
    Tested-by: Andrew Cooper <andrew.cooper3@citrix.com>


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

