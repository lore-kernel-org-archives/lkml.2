Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0INSfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:35:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48258 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab0INSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:35:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Date: Tue, 14 Sep 2010 11:35:28 -0700
Message-ID: <m1y6b48973.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch"
	<hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: [PATCH 0/5] Uio enhancements
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looking through my patch queue I stumbled upon some uio changes
that I have been using for a while and I forgot to push upstream.

Ultimately I am working on making uio devices hoptlugable, but I figure
I should get these enhancements in first.

Eric W. Biederman (5):
      uio: Fix lack of locking in init_uio_class
      uio: Don't clear driver data
      uio: Cleanup irq handling.
      uio: Support 2^MINOR_BITS minors
      uio: Statically allocate uio_class and use class .dev_attrs.
---
 drivers/uio/uio.c          |  165 +++++++++++++++++++-------------------------
 include/linux/uio_driver.h |    2 +-
 2 files changed, 71 insertions(+), 96 deletions(-)
