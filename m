Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2JZBM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 21:12:26 -0400
Received: from mx12.netapp.com ([216.240.18.77]:30043 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab2JZBMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 21:12:24 -0400
X-IronPort-AV: E=Sophos;i="4.80,650,1344236400"; 
   d="scan'208";a="277311713"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Please pull more NFS related bugfixes
Thread-Topic: [GIT PULL] Please pull more NFS related bugfixes
Thread-Index: AQHNsxbzSHsBlhUzYUW4TgAgez1PZA==
Date: Fri, 26 Oct 2012 01:12:22 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA909293049@SACEXCMBX04-PRD.hq.netapp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0172666A1077424BB0F592B807D367AB@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9Q1CXUu022223

Hi Linus,

This pull fixes a fairly urgent issue with the NFSv2/v3 statd code that
is causing Oopses, as well as some long standing races with the SUNRPC
tcp code.

The following changes since commit 0e9e3e306c7e472bdcffa34c4c4584301eda03b3:

  Merge tag 'stable/for-linus-3.7-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2012-10-24 05:17:27 +0300)

are available in the git repository at:


  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tags/nfs-for-3.7-3

for you to fetch changes up to e498daa81295d02f7359af313c2b7f87e1062207:

  LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero (2012-10-24 10:46:22 -0400)

----------------------------------------------------------------
NFS bugfixes for Linux 3.7

- Fix the NFSv2/v3 kernel statd protocol, which broke due to net namespace
  related changes.
- Fix a number of races in the SUNRPC TCP disconnect/reconnect code.

----------------------------------------------------------------
Trond Myklebust (6):
      SUNRPC: Clear the connect flag when socket state is TCP_CLOSE_WAIT
      Revert "SUNRPC: Ensure we close the socket on EPIPE errors too..."
      SUNRPC: Prevent races in xs_abort_connection()
      SUNRPC: Get rid of the xs_error_report socket callback
      LOCKD: fix races in nsm_client_get
      LOCKD: Clear ln->nsm_clnt only when ln->nsm_users is zero

 fs/lockd/mon.c        | 57 +++++++++++++++++++++++++++++----------------------
 net/sunrpc/xprtsock.c | 41 +++++++++---------------------------
 2 files changed, 42 insertions(+), 56 deletions(-)

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
