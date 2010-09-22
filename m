Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0IVUaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:30:14 -0400
Received: from nm3.bullet.mail.ne1.yahoo.com ([98.138.90.66]:33274 "HELO
	nm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751392Ab0IVUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:30:12 -0400
X-Yahoo-Newman-Id: 663031.33071.bm@omp1006.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: J2G_mo4VM1l.4bLlB7zYr9kSUN50auKm0wfZnbFA5sXphJE
 e3BFHstPozvEjlffopzHtmcJnaeEdFDLoftOXcOWIS9SC8U_lRqDF15orXDN
 a4JRROyr7UC_YfOKkYWfIO7v89ebDXcOlHG0pkjYkORl2NnsMqu9S.XVEzJt
 BkzGcfsAesooZZnT4rUinyf5rNmI2PzvaQnzshhU0QMzMqbY2tefiPG7pugp
 US1SuNrNjluHA0d8ybyn7I9ojidz3yu5AkLSIcGo0THK7cnN14zL8YSh2SoX
 KY2fqLyJhUj2My2ytuWjH9LdkmccDPy8FGqzT6aRUjuWMlgVQ61O26mE621a
 nsfdBOhNNhQO_ywh47v0-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>
Cc: David Miller <davem@davemloft.net>, Matthew Wilcox <willy@linux.intel.com>,
        Andi Keen <ak@linux.intel.com>, Roland Dreier <rdreier@cisco.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 0/2] siw: Fix build failure for > v2.6.34 + add crc32c-intel.ko offload
Date: Wed, 22 Sep 2010 13:30:08 -0700
Message-Id: <1285187408-10905-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Bernard and NetDev folks,

Attached are two patches for softiwarp/kernel.git, the first of which fixes a build
failure on > v2.6.34 kernels with ib_register_device(), and the second is the addition
of proper support for libcrypto crc32c-intel.ko using Nehalem SSE v4.2 instruction offload
which is an item that has been recently added into our LIO-Target v4.0.0-rc4 release
over on the linux-scsi list.

Please note that this code has only been compile tested so far, but I do plan to have
a deeper look at your teams work once I have a bit more free time on my hands.

Many great thanks for all of your efforts with IBM Software iWARP stack!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  siw: Fix ib_register_device() for > v2.6.34 kernels
  siw: Add support for CRC32C offload instruction using libcrypto
    crc32c-intel

 softiwarp/siw_main.c  |    5 ++++-
 softiwarp/siw_verbs.c |   37 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

