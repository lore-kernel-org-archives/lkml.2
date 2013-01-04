Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069Ab3ADPzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 10:55:18 -0500
Received: from mx12.netapp.com ([216.240.18.77]:34627 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab3ADPzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 10:55:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,411,1355126400"; 
   d="scan'208";a="4726586"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Xi Wang <xi.wang@gmail.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] nfs: fix null checking in nfs_get_option_str()
Thread-Topic: [PATCH] nfs: fix null checking in nfs_get_option_str()
Thread-Index: AQHN6lS73LR1xiXb7keBR/K9mZxOtpg52S6A
Date: Fri, 4 Jan 2013 15:55:09 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA91198A9EC@SACEXCMBX04-PRD.hq.netapp.com>
References: <1357287777-12052-1-git-send-email-xi.wang@gmail.com>
In-Reply-To: <1357287777-12052-1-git-send-email-xi.wang@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-7"
Content-ID: <6A9BBB99A0312748B10A36BED130B31E@tahoe.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-04 at 03:22 -0500, Xi Wang wrote:
+AD4- The following null pointer check is broken.
+AD4- 
+AD4- 	+ACo-option +AD0- match+AF8-strdup(args)+ADs-
+AD4- 	return +ACE-option+ADs-
+AD4- 
+AD4- The pointer +AGA-option' must be non-null, and thus +AGAAIQ-option' is always false.
+AD4- Use +AGAAIQAq-option' instead.
+AD4- 
+AD4- The bug was introduced in commit c5cb09b6f8 (+ACI-Cleanup: Factor out some
+AD4- cut-and-paste code.+ACI-).
+AD4- 
+AD4- Signed-off-by: Xi Wang +ADw-xi.wang+AEA-gmail.com+AD4-
+AD4- Cc: stable+AEA-vger.kernel.org
+AD4- ---
+AD4-  fs/nfs/super.c +AHw-    2 +--
+AD4-  1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4- 
+AD4- diff --git a/fs/nfs/super.c b/fs/nfs/super.c
+AD4- index c25cadf8..2e7e8c8 100644
+AD4- --- a/fs/nfs/super.c
+AD4- +-+-+- b/fs/nfs/super.c
+AD4- +AEAAQA- -1152,7 +-1152,7 +AEAAQA- static int nfs+AF8-get+AF8-option+AF8-str(substring+AF8-t args+AFsAXQ-, char +ACoAKg-option)
+AD4-  +AHs-
+AD4-  	kfree(+ACo-option)+ADs-
+AD4-  	+ACo-option +AD0- match+AF8-strdup(args)+ADs-
+AD4- -	return +ACE-option+ADs-
+AD4- +-	return +ACEAKg-option+ADs-
+AD4-  +AH0-
+AD4-  
+AD4-  static int nfs+AF8-get+AF8-option+AF8-ul(substring+AF8-t args+AFsAXQ-, unsigned long +ACo-option)

Thank you+ACE- Applied to the bugfixes branch.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust+AEA-netapp.com
www.netapp.com
