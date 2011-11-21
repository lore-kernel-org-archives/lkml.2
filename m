Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab1KUJy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:54:27 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60446 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab1KUJy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:54:26 -0500
Date: Mon, 21 Nov 2011 15:24:05 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Vivek Goyal <vgoyal@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Luck, Tony" <tony.luck@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, anderson@redhat.com,
        tachibana@mxm.nes.nec.co.jp, oomichi@mxs.nes.nec.co.jp,
        Valdis.Kletnieks@vt.edu, Nick Bowler <nbowler@elliptictech.com>
Subject: [RFC Patch 0/2] Slimdump framework using CRASH_REASON - v2
Message-ID: <20111121095405.GA2289@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11112023-7014-0000-0000-0000001D67D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,
	In furtherance of the previous discussion regarding 'slimdump'
(refer: http://article.gmane.org/gmane.linux.kernel/1204967), it was
decided that,

- An entry in VMCOREINFO elf-note be added to denote the cause of crash,
  instead of creating a new elf-note.

- Upstream tools such as 'makedumpfile' and 'crash' be modified to
  recognise this string and inform the user accordingly.

Accordingly, this new version of the patchset makes the following
changes 

Changelog - version 2
-----------------------
(First version posted here:
http://article.gmane.org/gmane.linux.kernel/1198435)

- Append VMCOREINFO elf-note with a new variable CRASH_REASON whose
  value will be populated using arch_add_crash_reason() function.

- Define arch_add_crash_reason() in the x86 MCE path to return "PANIC_MCE"
  in the panic path of MCE.

- 'makedumpfile' tool is taught to recognise PANIC_MCE string as one
  value of CRASH_REASON for which 'slimdump' must be captured.

- Changes to 'crash' tool are not included, and is deferred till there's
  consensus to the kernel and makedumpfile patches.

Let me know your comments on this.

Thanks,
K.Prasad

