Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1EIFra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 01:47:30 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40875 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1EIFr3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 01:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Jg1bTN860fEzak+YTtwej7CQ7W4a9pvKA+Eh7g8w+h8XmveRDS+AuIbRoeqG1zmFIy
         8oipGtREVPSbcBReTDWDg8Gb3J9YskMObHBMxcLiPiDfp2VHyG6Us2s5vNrGV7RFIsJj
         KlVDnaI6bSlQ/6Az6Sd41hWiE2TsGub/r4hdY=
MIME-Version: 1.0
Date: Sun, 8 May 2011 22:47:28 -0700
Message-ID: <BANLkTim-oWLjNdZmyNPsHypS+9uJNfOPHg@mail.gmail.com>
Subject: [PATCH] kvm/emulate.c warnings
From: Connor H <cmdkhh@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ make allmodconfig
$ make
.....
arch/x86/kvm/emulate.c: In function 'emulate_sysexit':
arch/x86/kvm/emulate.c:1706: warning: 'cs_sel' may be used
uninitialized in this function
arch/x86/kvm/emulate.c:1706: warning: 'ss_sel' may be used
uninitialized in this function
......


patch to fix warnings.

--- a/arch/x86/kvm/emulate.c    2011-05-03 23:28:18.000000000 +0000
+++ b/arch/x86/kvm/emulate.c    2011-05-08 21:07:19.000000000 +0000
@@ -1703,7 +1703,7 @@
       struct desc_struct cs, ss;
       u64 msr_data;
       int usermode;
-       u16 cs_sel, ss_sel;
+       u16 cs_sel=0, ss_sel=0;

       /* inject #GP if in real mode or Virtual 8086 mode */
       if (ctxt->mode == X86EMUL_MODE_REAL ||
