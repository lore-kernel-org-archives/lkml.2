Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715Ab0LNJ44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:56:56 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58429 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758578Ab0LNJ4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:56:53 -0500
Message-ID: <4D073F9B.7060002@cn.fujitsu.com>
Date: Tue, 14 Dec 2010 17:57:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm,x86: return true when user space query KVM_CAP_USER_NMI
 extension
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 17:56:50,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-14 17:56:52,
	Serialize complete at 2010-12-14 17:56:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

userspace may check this extension in runtime.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdac9e5..3d6b9ec 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1909,6 +1909,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_NOP_IO_DELAY:
 	case KVM_CAP_MP_STATE:
 	case KVM_CAP_SYNC_MMU:
+	case KVM_CAP_USER_NMI:
 	case KVM_CAP_REINJECT_CONTROL:
 	case KVM_CAP_IRQ_INJECT_STATUS:
 	case KVM_CAP_ASSIGN_DEV_IRQ:
