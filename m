Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab1JSOvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:51:33 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38422 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab1JSOva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:30 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC -v2] x86 RAS: Reorganize functionality
Date: Wed, 19 Oct 2011 16:50:57 +0200
Message-Id: <1319035866-29570-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

this is the second version of a first attempt at reorganizing and
concentrating x86 RAS features under arch/x86/. The idea is to put them
close to the MCA code so that code reuse and extending functionality can
be done much more easily.

This deals only with AMD RAS features but I expect that we can put
all into one unified menu entry in Kconfig after we've agreed on the
structure. Tony, let me know what from below makes sense or not - once
we've agreed on the hierarchy, we should move the Intel pieces there
too. Right now with this patchset we have:

[*] Machine Check / overheating reporting
[ ]   Intel MCE features
      AMD RAS features  --->
	[*] Error Thresholding (NEW)
	<*> Decode MCEs in human-readable form (NEW)
	< >   Inject MCEs (NEW)


and what I actually would like to see is something like

[ ] Reliability, Availability, Serviceability
[ ]  Machine Check Architecture
[ ]	Intel-specific features
	[ ] CMCI / overheating reporting
	[ ] MCE decoding
	[ ] MCE injection
[ ]	AMD-specific features
	[ ] Error thresholding
	[ ] MCE decoding
	[ ] MCE injection
[ ] ...

and where further features will be added. How does that sound?

Patches 5-9 add the hw MCE injection for AMD which is contingent on the
MCE injection module.

As always, all comments are welcome.

Thanks.
