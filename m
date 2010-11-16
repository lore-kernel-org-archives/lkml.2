Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab0KPOVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 09:21:23 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:53846 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753980Ab0KPOVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 09:21:22 -0500
From: Thomas Hellstrom <thellstrom@vmware.com>
To: airlied@redhat.com
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Introduce kref_sub
Date: Tue, 16 Nov 2010 15:21:06 +0100
Message-Id: <1289917268-4922-1-git-send-email-thellstrom@vmware.com>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a function in order to be able to optimize away a number of locked
bus cycles. Callers might for whatever reason want to accumulate unreferences
in certain code paths (rcu grace periods, atomic regions ...). This makes
it possible to perform the batched unreference more efficiently.

If accepted, I'd prefer patch 1 goes through Dave's DRM tree.

