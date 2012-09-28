Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030351Ab2I1TCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:02:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030262Ab2I1TCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:02:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 174/262] x86, avx: dont use avx instructions with "noxsave" boot param
Date: Fri, 28 Sep 2012 11:51:43 -0700
Message-Id: <20120928183018.599659336@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suresh Siddha <suresh.b.siddha@intel.com>

commit c6fd893da927c6cefb2ece22402765379921a834 upstream.

Clear AVX, AVX2 features along with clearing XSAVE feature bits,
as part of the parsing "noxsave" parameter.

Fixes the kernel boot panic with "noxsave" boot parameter.

We could have checked cpu_has_osxsave along with cpu_has_avx etc, but Peter
mentioned clearing the feature bits will be better for uses like
static_cpu_has() etc.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/common.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -144,6 +144,8 @@ static int __init x86_xsave_setup(char *
 {
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVEOPT);
+	setup_clear_cpu_cap(X86_FEATURE_AVX);
+	setup_clear_cpu_cap(X86_FEATURE_AVX2);
 	return 1;
 }
 __setup("noxsave", x86_xsave_setup);


