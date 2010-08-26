Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0HZStX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:49:23 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:33445 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0HZStV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:21 -0400
Subject: [PATCH 00/13] cciss: clean up cciss_ioctl()
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:55:28 -0500
Message-ID: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches factors out all of cases of the giant
switch statement in cciss_ioctl into separate functions.  And
there's one patch at the end that gets rid of some superfluous
if statements in the big passthru path.

I've run test programs that exercise all these ioctls and they
appear to still work.
---

Stephen M. Cameron (13):
      cciss: factor out cciss_getpciinfo
      cciss: factor out cciss_getintinfo
      cciss: factor out cciss_setintinfo
      cciss: factor out cciss_getnodename
      cciss: factor out cciss_setnodename
      cciss: factor out cciss_getheartbeat
      cciss: factor out cciss_getbustypes
      cciss: factor out cciss_getfirmver
      cciss: factor out cciss_getdrivver
      cciss: factor out cciss_getluninfo
      cciss: factor out cciss_passthru
      cciss: factor out cciss_big_passthru
      cciss: remove some superfluous tests from cciss_bigpassthru()


 drivers/block/cciss.c |  842 ++++++++++++++++++++++++-------------------------
 1 files changed, 412 insertions(+), 430 deletions(-)

--
-- steve
