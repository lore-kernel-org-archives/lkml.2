Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0IMRia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 13:38:30 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:43855 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0IMRi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 13:38:29 -0400
Message-ID: <4C8E6192.2010003@mandriva.org>
Date: Mon, 13 Sep 2010 20:38:26 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; sv-SE; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: stable@kernel.org
CC: Greg KH <gregkh@suse.de>, Larry.Finger@lwfinger.net,
        linux-kernel@vger.kernel.org
Subject: [33-stable regression ssb/broadcom]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Mandriva 2010.1 we noticed that 2.6.33.7 broke ssb/Broadcom lan for 
several users...

Issue is tracked at:
https://qa.mandriva.com/show_bug.cgi?id=60968

Reverting the commit restores a working lan.

The offending commit is:

--- cut ---
 From 6fb037c2ed8378c7ab0c1e00536ba6b2a866503e Mon Sep 17 00:00:00 2001
From: Christoph Fritz <chf.fritz@googlemail.com>
Date: Sun, 11 Jul 2010 18:26:15 -0500
Subject: [PATCH] ssb: Handle Netbook devices where the SPROM address is 
changed

For some Netbook computers with Broadcom BCM4312 wireless interfaces,
the SPROM has been moved to a new location. When the ssb driver tries to
read the old location, the systems hangs when trying to read a
non-existent location. Such freezes are particularly bad as they do not
log the failure.

This patch is modified from commit
da1fdb02d9200ff28b6f3a380d21930335fe5429 with some pieces from other
mainline changes so that it can be applied to stable 2.6.34.Y.
--- cut ---

--
Thomas
