Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932947Ab2EDUtr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 16:49:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab2EDUtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:49:43 -0400
Message-Id: <20120504204247.868714186@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Matthew Garrett <mjg@redhat.com>,
        Mike Waychison <mikew@google.com>, Tony Luck <tony.luck@intel.com>
Subject: [ 35/47] efivars: fix warnings when CONFIG_PSTORE=n
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit b728a5c806fb36f9adebf2a862bbd015e074afca upstream.

drivers/firmware/efivars.c:161: warning: ‘utf16_strlen’ defined but not used
utf16_strlen() is only used inside CONFIG_PSTORE - make this "static inline"
to shut the compiler up [thanks to hpa for the suggestion].

drivers/firmware/efivars.c:602: warning: initialization from incompatible pointer type
Between v1 and v2 of this patch series we decided to make the "part" number
unsigned - but missed fixing the stub version of efi_pstore_write()

Acked-by: Matthew Garrett <mjg@redhat.com>
Acked-by: Mike Waychison <mikew@google.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
[took the static part of the patch, not the pstore part, for 3.0-stable,
to fix the compiler warning we had - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -150,7 +150,7 @@ utf16_strnlen(efi_char16_t *s, size_t ma
 	return length;
 }
 
-static unsigned long
+static inline unsigned long
 utf16_strlen(efi_char16_t *s)
 {
 	return utf16_strnlen(s, ~0UL);


