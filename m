Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab0JVTWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:22:52 -0400
Received: from kroah.org ([198.145.64.141]:33959 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759222Ab0JVS4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:00 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:28 2010
Message-Id: <20101022185228.758769469@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:50:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [016/103] oprofile: Add Support for Intel CPU Family 6 / Model 29
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Olsa <jolsa@redhat.com>

commit bb7ab785ad05a97a2c9ffb3a06547ed39f3133e8 upstream.

This patch adds CPU type detection for dunnington processor (Family 6
/ Model 29) to be identified as core 2 family cpu type (wikipedia
source).

I tested oprofile on Intel(R) Xeon(R) CPU E7440 reporting itself as
model 29, and it runs without an issue.

Spec:

 http://www.intel.com/Assets/en_US/PDF/specupdate/320336.pdf

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -674,6 +674,7 @@ static int __init ppro_init(char **cpu_t
 	case 0x0f:
 	case 0x16:
 	case 0x17:
+	case 0x1d:
 		*cpu_type = "i386/core_2";
 		break;
 	case 0x1a:


