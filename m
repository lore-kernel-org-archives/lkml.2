Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab0JEIwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 04:52:33 -0400
Received: from smtp.nokia.com ([192.100.105.134]:17150 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317Ab0JEIwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 04:52:31 -0400
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: m.nazarewicz@samsung.com, mingo@elte.hu, gregkh@suse.de,
        a.p.zijlstra@chello.nl, xiaosuo@gmail.com,
        linux-kernel@vger.kernel.org, ext-eugeny.kuznetsov@nokia.com
Subject: [PATCH 0/1] wait: using uninitialized member of wait queue
Date: Tue,  5 Oct 2010 12:47:56 +0400
Message-Id: <cover.1286193121.git.EXT-Eugeny.Kuznetsov@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 05 Oct 2010 08:51:32.0711 (UTC) FILETIME=[82643F70:01CB646A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is patch which fixes bug in /include/linux/wait.h file.
Member "flags" of "wait_queue_t" struct  is used in several places in
kernel code without beeing initialized. "flags" is used in bitwise
operations. If it contain dummy data then incorrect flags may be 
used later in code.

Thanks,
Best Regards,
Evgeny

Evgeny Kuznetsov (1):
  wait: using uninitialized member of wait queue

 include/linux/wait.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

