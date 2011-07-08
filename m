Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1GHCHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 22:07:04 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:52883 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753477Ab1GHCHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 22:07:02 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18oY65082UoPyFSPc5R0rz5YeBfoIElU4CSE8hXkA
	z/bY3YysZMvp7R
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [000/107] 2.6.39.3 review
Date: Fri, 8 Jul 2011 04:06:24 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-2.slh.1-aptosid-686; KDE/4.6.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
References: <20110708001740.GA14031@kroah.com>
In-Reply-To: <20110708001740.GA14031@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107080406.26686.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 08 July 2011, Greg KH wrote:
[...]
> Responses should be made by Sat, Jul 9, 2011, 00:00:00 UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.39.3-rc1.gz
> and the diffstat can be found below.

The patch series from queue-2.6.39[1] (a) and patch-2.6.39.3-rc1.gz (b)
differ, leading to a build failure due to gss_krb5_enctypes.h missing 
from patch-2.6.39.3-rc1.gz


diff -Nrup a/include/linux/sunrpc/gss_krb5_enctypes.h b/include/linux/sunrpc/gss_krb5_enctypes.h
--- a/include/linux/sunrpc/gss_krb5_enctypes.h
+++ /dev/null
@@ -1,4 +0,0 @@
-/*
- * Dumb way to share this static piece of information with nfsd
- */
-#define KRB5_SUPPORTED_ENCTYPES "18,17,16,23,3,1,2"


Apparently the hunk creating include/linux/sunrpc/gss_krb5_enctypes.h 
in nfsd-fix-dependency-of-nfsd-on-auth_rpcgss.patch hasn't made it to
patch-2.6.39.3-rc1.gz, while it exists in [2].

Regards
	Stefan Lippers-Hollmann

[1]	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=tree;f=queue-2.6.39;hb=refs/heads/master
[2]	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.39/nfsd-fix-dependency-of-nfsd-on-auth_rpcgss.patch;hb=refs/heads/master
