Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab1IUWnC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 18:43:02 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:21921 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1IUWmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 18:42:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: [PATCH] xen-pciback patches for 3.2 (s/spinlock/mutex/)
Date: Wed, 21 Sep 2011 18:42:44 -0400
Message-Id: <1316644966-19386-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A020206.4E7A686C.002C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

402c5e1 xen/pciback: miscellaneous adjustments
04df355 xen/pciback: use mutex rather than spinlock in passthrough backend
5fa9991 xen/pciback: use resource_size()

which I've in the stable/drivers.bugfixes on oss.oracle.com
(git://oss.oracle.com/git/kwilk/xen.git) I am proposing these
two patches.

The easier of them: 
  xen/pciback: use mutex rather than spinlock in vpci backend

converts the vpci backend to use the same mechanism as the passthrough backend.

 xen/pciback: Use mutexes when working with Xenbus state transitions.

converts the spinlocks that are guarding the Xenbus state changes to be
mutexs and moves them out to be in similar locations as in the 2.6.18 tree.

