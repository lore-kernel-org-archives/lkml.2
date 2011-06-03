Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1FCSHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:07:09 -0400
Received: from tn-76-7-162-101.sta.embarqhsd.net ([76.7.162.101]:35036 "EHLO
	animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752716Ab1FCSHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:07:07 -0400
X-Greylist: delayed 1296 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 14:07:06 EDT
Date: Fri, 3 Jun 2011 13:45:28 -0400
From: Wakko Warner <wakko@animx.eu.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.39 nfsd and crypto =n
Message-ID: <20110603174528.GA1368@animx.eu.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6+20040907i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During compile, I received this:
ERROR: "crypto_destroy_tfm" [fs/nfsd/nfsd.ko] undefined!
ERROR: "crypto_alloc_base" [fs/nfsd/nfsd.ko] undefined!

.config nfsd options:
CONFIG_NFSD=m
# CONFIG_NFSD_DEPRECATED is not set
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y

and crypto:
# CONFIG_CRYPTO is not set

making the following change fixes:
-# CONFIG_CRYPTO is not set
+CONFIG_CRYPTO=m

Should NFSD_V4 select CRYPTO?  Should it select other things?

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
