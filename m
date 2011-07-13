Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1GMPeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:34:31 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:33763 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab1GMPdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:33:17 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzzz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37A-02-9JD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] Implement Shadow VMCB for Nested SVM
Date: Wed, 13 Jul 2011 17:32:18 +0200
Message-ID: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

here is a patch-set that implements a shadow-vmcb for nested SVM. The
shadow-vmcb is always used when the L2-guest is invoked. This saves some
memory copys in the nested vmrun and vmexit paths because the contents
of the host-vmcb do not need to be saved/restored anymore.

This patch-set also prepares nested-svm for the emulation of clean-bits.

Regards,

	Joerg

Diffstat:

 arch/x86/kvm/svm.c |  248 ++++++++++++++++++++++++----------------------------
 1 files changed, 114 insertions(+), 134 deletions(-)


