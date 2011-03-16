Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1CPId6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 04:33:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33274 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab1CPIdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 04:33:41 -0400
Subject: [PATCH v2 2/5] dt: protect against NULL matches passed to
 of_match_node()
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 16 Mar 2011 02:33:38 -0600
Message-ID: <20110316083338.1154.68708.stgit@localhost6.localdomain6>
In-Reply-To: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
References: <20110316083046.1154.89723.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few use cases where it is convenient to pass NULL to
of_match_node() and have it fail gracefully.  The patch adds a null
check to the beginning so taht it does so.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 710b53b..632ebae7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -496,6 +496,9 @@ EXPORT_SYMBOL(of_find_node_with_property);
 const struct of_device_id *of_match_node(const struct of_device_id *matches,
 					 const struct device_node *node)
 {
+	if (!matches)
+		return NULL;
+
 	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
 		int match = 1;
 		if (matches->name[0])

