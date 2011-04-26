Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514Ab1DZVXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:23:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:61258 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433Ab1DZVOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="634483745"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: JBeulich@novell.com, jbeulich@novell.com, ak@linux.intel.com,
        stable@kernel.org, dtor@mail.ru, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [80/106] Input: synaptics - fix crash in synaptics_module_init()
Message-Id: <20110426211401.EB4B53E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:14:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jan Beulich <JBeulich@novell.com>

[ upstream commit 708748670c7c6dd5bd3b141473086e6937e72737 ]

'struct dmi_system_id' arrays must always have a terminator to keep
dmi_check_system() from looking at data (and possibly crashing) it
isn't supposed to look at.

The issue went unnoticed until ef8313bb1a22e7d2125d9d758aa8a81f1de91d81,
but was introduced about a year earlier with
7705d548cbe33f18ea7713b9a07aa11047aaeca4 (which also similarly changed
lifebook.c, but the problem there got eliminated shortly afterwards).

The first hunk therefore is a stable candidate back to 2.6.33, while
the full change is needed only on 2.6.38.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: stable@kernel.org
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

Index: linux-2.6.35.y/drivers/input/mouse/synaptics.c
===================================================================
--- linux-2.6.35.y.orig/drivers/input/mouse/synaptics.c
+++ linux-2.6.35.y/drivers/input/mouse/synaptics.c
@@ -712,8 +712,8 @@ static const struct dmi_system_id __init
 		},
 
 	},
-	{ }
 #endif
+	{ }
 };
 
 void __init synaptics_module_init(void)
