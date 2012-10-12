Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2JLXUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 19:20:03 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51125
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab2JLXUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 19:20:01 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] tools: hv: Return the full kernel version
Date: Fri, 12 Oct 2012 16:40:10 -0700
Message-Id: <1350085210-11108-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we are returning the same string for both OSBuildNumber 
and OSVersion keys. Return the full uts string for the OSBuild
key since Windows does not impose any restrictions on this. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Claudio Latini <claudio.latini@live.com>
---
 tools/hv/hv_kvp_daemon.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 5959aff..6c7bcb9 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -88,6 +88,7 @@ static char *os_major = "";
 static char *os_minor = "";
 static char *processor_arch;
 static char *os_build;
+static char *os_version;
 static char *lic_version = "Unknown version";
 static struct utsname uts_buf;
 
@@ -453,7 +454,9 @@ void kvp_get_os_info(void)
 	char	*p, buf[512];
 
 	uname(&uts_buf);
-	os_build = uts_buf.release;
+	os_version = uts_buf.release;
+	os_build = strdup(uts_buf.release);
+
 	os_name = uts_buf.sysname;
 	processor_arch = uts_buf.machine;
 
@@ -462,7 +465,7 @@ void kvp_get_os_info(void)
 	 * string to be of the form: x.y.z
 	 * Strip additional information we may have.
 	 */
-	p = strchr(os_build, '-');
+	p = strchr(os_version, '-');
 	if (p)
 		*p = '\0';
 
@@ -1649,7 +1652,7 @@ int main(void)
 			strcpy(key_name, "OSMinorVersion");
 			break;
 		case OSVersion:
-			strcpy(key_value, os_build);
+			strcpy(key_value, os_version);
 			strcpy(key_name, "OSVersion");
 			break;
 		case ProcessorArchitecture:
-- 
1.7.4.1

