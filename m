Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab2IDPzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885Ab2IDPzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:55:37 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: [RFC] First attempt at kernel secure boot support 
Date: Tue,  4 Sep 2012 11:55:06 -0400
Message-Id: <1346774117-2277-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.233.206
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UEFI Secure Boot trust model is based on it not being possible for a
user to cause a signed OS to boot an unsigned OS, even if that user has
administrative privileges. This is an initial attempt at a set of patches
to reduce root's ability to modify the kernel. We've done this with an
additional capability for a couple of reasons:

1) CAP_SYS_RAWIO already covers pretty much everything we want, but also
   disables a lot of functionality that we don't want to lose. Following
   the same model seems reasonable.
2) This capability may be more generically useful for some use-cases.
   Adding a set of hardcoded is_secure_boot() checks in the same places would
   prevent that.

Feedback welcome.

-- 
Matthew Garrett | mjg59@srcf.ucam.org

