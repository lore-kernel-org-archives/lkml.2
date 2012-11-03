Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2KCUad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 16:30:33 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:36725
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575Ab2KCUac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 16:30:32 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161264923"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Subject: [PATCH 0/8] drop if around WARN_ON
Date: Sat,  3 Nov 2012 21:30:17 +0100
Message-Id: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches convert a conditional with a simple test expression and a
then branch that only calls WARN_ON(1) to just a call to WARN_ON, which
will test the condition.

// <smpl>
@@
expression e;
@@

(
if(<+...e(...)...+>) WARN_ON(1);
|
- if (e) WARN_ON(1);
+ WARN_ON(e);
)// </smpl>

