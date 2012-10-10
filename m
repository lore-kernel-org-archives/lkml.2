Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab2JKA0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 20:26:11 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54188 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933470Ab2JKAZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 20:25:41 -0400
X-Sasl-enc: M2XCBkhnY69nEIoQzasVFf3c6O9F5J/uhnPZqKISOpiR 1349915140
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>, Josh Boyer <jwboyer@redhat.com>
Subject: [ 104/122] efi: Build EFI stub with EFI-appropriate options
Date: Thu, 11 Oct 2012 07:54:30 +0900
Message-Id: <20121010225356.756423506@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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


