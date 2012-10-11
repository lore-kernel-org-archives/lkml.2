Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638Ab2JKBOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:14:14 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57478 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933084Ab2JKBOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:14:09 -0400
X-Sasl-enc: V/k8m4iY5K22b/5+bNy+oLJSF9hwi/E49tiLryEwuOrk 1349918047
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>, Josh Boyer <jwboyer@redhat.com>
Subject: [ 105/120] efi: Build EFI stub with EFI-appropriate options
Date: Thu, 11 Oct 2012 10:00:57 +0900
Message-Id: <20121011005846.445969841@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit 9dead5bbb825d7c25c0400e61de83075046322d0 upstream.

We can't assume the presence of the red zone while we're still in a boot
services environment, so we should build with -fno-red-zone to avoid
problems. Change the size of wchar at the same time to make string handling
simpler.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Acked-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -28,6 +28,9 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
 	$(obj)/piggy.o
 
+$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
+$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
+
 ifeq ($(CONFIG_EFI_STUB), y)
 	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
 endif


