Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2BXLr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:47:59 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:35889 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab2BXLr6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 24 Feb 2012 06:47:58 -0500
Message-Id: <4F4786FD0200007800074A0C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Feb 2012 11:47:57 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: constify all instances of "struct
 attribute_group"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions these get passed to have been taking pointers to const
since at least 2.6.16.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/sys-hypervisor.c  |    6 +++---
 drivers/xen/xen-balloon.c     |    2 +-
 drivers/xen/xen-selfballoon.c |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

--- 3.3-rc4/drivers/xen/sys-hypervisor.c
+++ 3.3-rc4-xen-const-attribute_group/drivers/xen/sys-hypervisor.c
@@ -97,7 +97,7 @@ static struct attribute *version_attrs[]
 	NULL
 };
 
-static struct attribute_group version_group = {
+static const struct attribute_group version_group = {
 	.name = "version",
 	.attrs = version_attrs,
 };
@@ -210,7 +210,7 @@ static struct attribute *xen_compile_att
 	NULL
 };
 
-static struct attribute_group xen_compilation_group = {
+static const struct attribute_group xen_compilation_group = {
 	.name = "compilation",
 	.attrs = xen_compile_attrs,
 };
@@ -340,7 +340,7 @@ static struct attribute *xen_properties_
 	NULL
 };
 
-static struct attribute_group xen_properties_group = {
+static const struct attribute_group xen_properties_group = {
 	.name = "properties",
 	.attrs = xen_properties_attrs,
 };
--- 3.3-rc4/drivers/xen/xen-balloon.c
+++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-balloon.c
@@ -207,7 +207,7 @@ static struct attribute *balloon_info_at
 	NULL
 };
 
-static struct attribute_group balloon_info_group = {
+static const struct attribute_group balloon_info_group = {
 	.name = "info",
 	.attrs = balloon_info_attrs
 };
--- 3.3-rc4/drivers/xen/xen-selfballoon.c
+++ 3.3-rc4-xen-const-attribute_group/drivers/xen/xen-selfballoon.c
@@ -488,7 +488,7 @@ static struct attribute *selfballoon_att
 	NULL
 };
 
-static struct attribute_group selfballoon_group = {
+static const struct attribute_group selfballoon_group = {
 	.name = "selfballoon",
 	.attrs = selfballoon_attrs
 };



