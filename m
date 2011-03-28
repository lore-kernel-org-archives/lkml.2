Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1C1QV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:21:56 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:53372
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751744Ab1C1QVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:21:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 00/20] Staging: hv: Cleanup-storage-drivers-phase-II 
Date: Mon, 28 Mar 2011 09:32:30 -0700
Message-Id: <1301329950-25490-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch-set restructures and cleans up struct hv_storvsc_request.
In the current code, two data structures: struct hv_storvsc_request
and struct storvsc_request_extension together are used to carry
the I/O state and there are many issues with this current
architecture:

	1) The memory for extension data structure 
	   is allocatted just after the data buffer
	   field in struct hv_storvsc_request resulting in comments
	   such as this in struct blkvsc_request (blkvsc_drv.c):

	/*
	 * !!!DO NOT ADD ANYTHING BELOW HERE!!! Otherwise, memory can overlap,
	 * because - The extension buffer falls right here and is pointed to by
	 * request.Extension;
	 * Which sounds like a horrible idea, who designed this?
	 */


	2) State is unnecessarily replicated in both struct hv_storvsc_request
	   and the struct vstor_packet that is embedded in 
	   struct storvsc_request_extension.

This patch-set addresses the above issues by geting rid of replicated
state and consolidating all necessary state into a single data structure.
We also deal with a range of other cleanups in this patch-set:

	1) Use completion primitives to wait for completion.
	2) Get rid of the synch primitive in struct blkvsc_request
	3) Get rid of the need for struct hv_device to be the first
	   element of struct host_device_context.


Regards,

K. Y

