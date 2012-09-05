Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2IEPJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:09:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54127 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab2IEPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:09:35 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org
Subject: [PATCH 3.6 0/3] Fix use-after-free in PSCSI
Date: Wed,  5 Sep 2012 17:09:12 +0200
Message-Id: <1346857755-10224-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series fixes the bug I reported with wrong sense data.  The
memory corruption is caused by using the sense data after freeing
it.  The series corrects it by moving the copy of the sense data
earlier, to the transport_complete callback.

Please review and be kind on my first lio patches! :)

Paolo

Paolo Bonzini (3):
  target: move transport_get_sense_data
  target: simplify code around transport_get_sense_data
  target: fix use-after-free with PSCSI sense data

 drivers/target/target_core_pscsi.c     |   21 ++----
 drivers/target/target_core_transport.c |  117 ++++++++++++--------------------
 include/target/target_core_backend.h   |    4 +-
 3 files changed, 53 insertions(+), 89 deletions(-)

