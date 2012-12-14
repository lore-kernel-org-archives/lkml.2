Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab2LNMKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 07:10:34 -0500
Received: from callisto.mysnip.de ([178.23.121.164]:39359 "EHLO
	callisto.mysnip.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2LNMKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 07:10:33 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Dec 2012 07:10:33 EST
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/7] eCryptfs: added support for the encrypted key type
X-PHP-Originating-Script: 1000:email_functions.php
Content-Type: text/plain; charset=UTF-8
X-Mailer: Phorum5
Message-ID: <1c1575f5e47b34a02741b86d367a8617.LinuxKernel@www.serverphorums.com>
X-Phorum: 1a38330efb91e5f9021ae2fc13b39ae0412706f1
From: lkml@serverphorums.com
Date: Fri, 14 Dec 2012 13:00:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qBECAfGx000418

Hi there, 


Either this is completely braindead, or I'm missing something very obvious. 
Why mess up encrypted keys with various "format" fixes. 
I hope this doesn't start a trend. 

The right (and disturbingly simpler) approach to fixing the auth_token vs. 
raw key material issue would be to put the fix in eCryptfs. 

In fact, all the relevant bits for filling the token from the key_desc/sig should be moved 
from security/keys/encrypted/ecryptfs_format.c to fs/ecryptfs/ecryptfs_kernel.h, 
and all the format cruft in encrypted-keys reverted. 
Then pretty much any "default" encrypted key could be used for ecryptfs… 

What am I missing? 


--@;

---
posted at http://www.serverphorums.com
http://www.serverphorums.com/read.php?12,341340,618745#msg-618745
