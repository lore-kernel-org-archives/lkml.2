Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935Ab1COOLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:11:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19791 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab1COOLp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 15 Mar 2011 10:11:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: xen-devel@lists.xensource.com, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, dgdegra@tycho.nsa.gov
Subject: [PATCH] Add grant references for fbfront/kbdfront
Date: Tue, 15 Mar 2011 10:11:11 -0400
Message-Id: <1300198274-1325-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D7F7394.00E3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is proposed for 2.6.39.

The patchset description from:
http://lists.colo.xensource.com/archives/html/xen-devel/2011-03/msg00381.html

This series fixes the interface for the fbfront and kbdfront devices,
which were storing MFNs in xenstore rather than creating grant table
entries. To maintain backwards compatibility, a different xenstore key
is used (page-gref instead of page-ref) and the use of grants must be
requested for fbfront (because two levels of page references are
embedded within the shared page). This makes it possible to move a
display server out of dom0 without giving the display domain full access
to other domain's memory.

Changes since v1:
        Updated xenstore key to "feature-grants"

Updated frontend patch has been sent to qemu-devel.


 drivers/input/xen-kbdfront.c |   39 +++++++++----
 drivers/video/xen-fbfront.c  |  126 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 132 insertions(+), 33 deletions(-)

Daniel De Graaf (3):
      xen-fbfront: Read width/height from backend
      xen-kbdfront: Add grant reference for shared page
      xen-fbfront: Use grant references when requested

