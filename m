Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946283Ab2JDV0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:26:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45178 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946233Ab2JDVZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:25:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tomas Racek <tracek@redhat.com>, Avi Kivity <avi@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Ben Jencks <ben@bjencks.net>, qemu-devel@nongnu.org
Subject: [ 50/52] x86/alternatives: Fix p6 nops on non-modular kernels
Date: Thu,  4 Oct 2012 14:21:41 -0700
Message-Id: <20121004210641.663297238@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.372689554@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

commit cb09cad44f07044d9810f18f6f9a6a6f3771f979 upstream.

Probably a leftover from the early days of self-patching, p6nops
are marked __initconst_or_module, which causes them to be
discarded in a non-modular kernel.  If something later triggers
patching, it will overwrite kernel code with garbage.

Reported-by: Tomas Racek <tracek@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org
Cc: Anthony Liguori <anthony@codemonkey.ws>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/5034AE84.90708@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Ben Jencks <ben@bjencks.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/alternative.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -160,7 +160,7 @@ static const unsigned char * const k7_no
 #endif
 
 #ifdef P6_NOP1
-static const unsigned char  __initconst_or_module p6nops[] =
+static const unsigned char p6nops[] =
 {
 	P6_NOP1,
 	P6_NOP2,


