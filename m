Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab2JJRws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:52:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:20025 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2JJRwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:52:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH v1] Various bug-fixes for v3.6.
Date: Wed, 10 Oct 2012 13:40:46 -0400
Message-Id: <1349890849-17471-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Three patches that were discovered with v3.6. The first one:

 [PATCH 1/3] xen/pv-on-hvm kexec: add quirk for Xen 3.4 and shutdown
should have been found earlier, but it seems there is only a small selection
of provides run Xen 3.4 and without the 23839:42a45baf037d in xen-unstable.hg fix.
It is easy to reproduce with OVM 2.2 product.

The other two are a bit embarrassing. We had a similar issue with rdmsr_safe
pvops call in v3.5 where it was not implemented for Xen PV (but rdmsr was).
The fix was to make rdmsr_safe a macro around rdmsr and a lookout for other
calls that were not implemented. Well, v3.6 has gone by and now I find three other
culprits:
 [PATCH 2/3] xen/bootup: allow {read|write}_cr8 pvops call.
 [PATCH 3/3] xen/bootup: allow read_tscp call for Xen PV guests.
