Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459Ab1ESSeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:34:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40564 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934408Ab1ESScu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:32:50 -0400
X-Sasl-enc: eVkkYckaVd4bu89Ji2Z4ut8h97wJ0zihiZGElssPzOXr 1305829969
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:31:27 2011
Message-Id: <20110519183127.411610091@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:30:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Boris Ostrovsky <Boris.Ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Joerg-Volker-Peetz <jvpeetz@web.de>,
        Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Subject: [18/24] x86, AMD: Fix ARAT feature setting again
In-Reply-To: <20110519182446.GA23751@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1475
Lines: 39

From: Borislav Petkov <borislav.petkov@amd.com>

commit 14fb57dccb6e1defe9f89a66f548fcb24c374c1d upstream.

Trying to enable the local APIC timer on early K8 revisions
uncovers a number of other issues with it, in conjunction with
the C1E enter path on AMD. Fixing those causes much more churn
and troubles than the benefit of using that timer brings so
don't enable it on K8 at all, falling back to the original
functionality the kernel had wrt to that.

Reported-and-bisected-by: Nick Bowler <nbowler@elliptictech.com>
Cc: Boris Ostrovsky <Boris.Ostrovsky@amd.com>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
Cc: Nick Bowler <nbowler@elliptictech.com>
Cc: Joerg-Volker-Peetz <jvpeetz@web.de>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1305636919-31165-3-git-send-email-bp@amd64.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -566,7 +566,7 @@ static void __cpuinit init_amd(struct cp
 #endif
 
 	/* As a rule processors have APIC timer running in deep C states */
-	if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
+	if (c->x86 > 0xf && !cpu_has_amd_erratum(amd_erratum_400))
 		set_cpu_cap(c, X86_FEATURE_ARAT);
 
 	/*


