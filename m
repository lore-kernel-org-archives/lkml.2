Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab2HQHrK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:47:10 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:59030
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056Ab2HQHrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:47:05 -0400
X-IronPort-AV: E=Sophos;i="4.77,783,1336341600"; 
   d="scan'208";a="153240436"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] fix error return code
Date: Fri, 17 Aug 2012 09:46:55 +0200
Message-Id: <1345189618-13758-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fix cases where the return code appears to be unintentially
nonnegative.

The complete semantic match that finds the problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret,l;
expression e1,e2,e3;
statement S;
@@

if (ret < 0)
 { ... return ret; }
... when != ret = e1
    when forall
(
 goto l;
|
 return ...;
|
 if (<+... ret = e3 ...+>) S
|
*if(...)
 {
  ... when != ret = e2
* return ret;
}
)
// </smpl>

