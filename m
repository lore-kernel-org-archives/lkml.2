Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1HQODc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 10:03:32 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:57944 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606Ab1HQODa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 10:03:30 -0400
X-AuditID: 12074424-b7bcaae000000a05-71-4e4bca5cb555
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Fenghua Yu <fenghua.yu@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 0/2] Forcibly enable some MISC_ENABLE features on Intel
Date: Wed, 17 Aug 2011 10:03:17 -0400
Message-Id: <cover.1313586473.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsUixCmqrRtzytvPYN5WTYu+K0fZLdqmOVrs
	fPiWzWL5vn5Gi8u75rBZbLnUzGpx9eFsFosfGx6zOnB43Gr7w+yxc9Zddo/Fe14yeWxa1cnm
	se7GV3aPz5vkAtiiuGxSUnMyy1KL9O0SuDI6VpsWbGWvWPb0K2sD4xfWLkZODgkBE4nd/xoZ
	IWwxiQv31rN1MXJxCAnsY5RY8/U9M4SzgVHi/PUJjBDOMyaJSZe+grWzCahIdCx9wARiiwgY
	SGxZ+YIVpIhZ4AqjxMX5N5hBEsICXhL9LVvAGlgEVCV6/n4Ca+AV0Jf48vIBM8RuOYkjl58z
	TWDkWcDIsIpRNiW3Sjc3MTOnODVZtzg5MS8vtUjXXC83s0QvNaV0EyMoxNhdVHYwNh9SOsQo
	wMGoxMMb1O/lJ8SaWFZcmXuIUZKDSUmUN+6kt58QX1J+SmVGYnFGfFFpTmrxIUYJDmYlEV6f
	g0A53pTEyqrUonyYlDQHi5I4r81OBz8hgfTEktTs1NSC1CKYrAwHh5IEbxrIUMGi1PTUirTM
	nBKENBMHJ8hwHqDhk0FqeIsLEnOLM9Mh8qcYFaXEedNBEgIgiYzSPLheWAp4xSgO9IowbzhI
	FQ8wfcB1vwIazAQ0+NYuD5DBJYkIKakGRouvXFN6yuat++b7Z/msQvnFc6ti2DqXLvBoXXTh
	GeftI5eXZ13smLffJ+Ksw8a6g8zBJSIsaa/27ZE2eb/5s+wz5tj1G2WXSk+/E9122yPqUl+y
	huh6xoKm3zeOdmxpz2iX/NpYdurY5NzdDz1eF/ctTVVlP/0mJDtQ7OCqCTl302RaH8dcWazE
	UpyRaKjFXFScCADmhxDq3AIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel allows BIOS or the OS to enable or disable some CPU fueatures via
IA32_MISC_ENABLE.  I have machines that don't enable fast strings or
monitor/mwait in BIOS, so do it on bootup instead.

Changes from v3:
 - Don't display CPU index (and therefore don't break !SMP build)
 - Don't display "Failed to enable..." when kmemcheck is on

Changes from v2:
 - Don't linebreak printk messages (for ease of grepping)
 - Use printk_once
 - Update the "Disabled fast string operations" message

Changes from v1:
 - Display FW_WARN messages.
 - Don't change the kmemcheck message.
 - Improve the fast string comment.
 - Improve the changelogs.

Andy Lutomirski (2):
  x86: Enable fast strings on Intel if BIOS hasn't already
  x86: Enable monitor/mwait on Intel if BIOS hasn't already

 arch/x86/kernel/cpu/intel.c |   51 ++++++++++++++++++++++++++++++++++++++----
 1 files changed, 46 insertions(+), 5 deletions(-)

-- 
1.7.6

