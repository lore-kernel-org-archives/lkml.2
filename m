Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab2DPUVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:21:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab2DPUVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:21:51 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [EDAC_ABI PATCH v13 00/26] Use the new EDAC kernel ABI on drivers
Date: Mon, 16 Apr 2012 17:21:19 -0300
Message-Id: <1334607705-30320-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
References: <1334607133-30039-1-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the EDAC MC drivers to use the new ABI. For the csrow-based
memory controllers, no functional changes should be noticed.

RAMBUS, FB-DIMM, Nehalem and SandyBridge-EP will get an improvement
on this series, as the EDAC core will know the real memory config,
instead of relying on some fake/virtual information.

Yet, on the userspace ABI, nothing changes. A latter series will
fix the userspace ABI.

All those patches, except for the last one, were previously part of
a single patch:

	https://lkml.org/lkml/2012/3/29/305

That were also handling the EDAC core changes. However, in order to
simplify the driver review, the big patch were broken into a few
EDAC core changes and this series of patches.

Mauro Carvalho Chehab (26):
  amd64_edac: convert driver to use the new edac ABI
  amd76x_edac: convert driver to use the new edac ABI
  cell_edac: convert driver to use the new edac ABI
  cpc925_edac: convert driver to use the new edac ABI
  e752x_edac: convert driver to use the new edac ABI
  e7xxx_edac: convert driver to use the new edac ABI
  i3000_edac: convert driver to use the new edac ABI
  i3200_edac: convert driver to use the new edac ABI
  i5000_edac: convert driver to use the new edac ABI
  i5100_edac: convert driver to use the new edac ABI
  i5400_edac: convert driver to use the new edac ABI
  i7300_edac: convert driver to use the new edac ABI
  i7core_edac: convert driver to use the new edac ABI
  i82443bxgx_edac: convert driver to use the new edac ABI
  i82860_edac: convert driver to use the new edac ABI
  i82875p_edac: convert driver to use the new edac ABI
  i82975x_edac: convert driver to use the new edac ABI
  mpc85xx_edac: convert driver to use the new edac ABI
  mv64x60_edac: convert driver to use the new edac ABI
  pasemi_edac: convert driver to use the new edac ABI
  ppc4xx_edac: convert driver to use the new edac ABI
  r82600_edac: convert driver to use the new edac ABI
  sb_edac: convert driver to use the new edac ABI
  tile_edac: convert driver to use the new edac ABI
  x38_edac: convert driver to use the new edac ABI
  edac: Remove the legacy EDAC ABI

 drivers/edac/amd64_edac.c      |  137 +++++++++++++++++--------
 drivers/edac/amd76x_edac.c     |   28 ++++--
 drivers/edac/cell_edac.c       |   26 ++++--
 drivers/edac/cpc925_edac.c     |   23 ++++-
 drivers/edac/e752x_edac.c      |   49 ++++++---
 drivers/edac/e7xxx_edac.c      |   37 ++++++--
 drivers/edac/edac_core.h       |   78 +--------------
 drivers/edac/edac_mc.c         |   53 +----------
 drivers/edac/i3000_edac.c      |   25 ++++-
 drivers/edac/i3200_edac.c      |   32 ++++--
 drivers/edac/i5000_edac.c      |   60 +++++++----
 drivers/edac/i5100_edac.c      |   90 ++++++++---------
 drivers/edac/i5400_edac.c      |  217 ++++++++++++++++++++++------------------
 drivers/edac/i7300_edac.c      |   81 ++++++---------
 drivers/edac/i7core_edac.c     |  202 +++++++++----------------------------
 drivers/edac/i82443bxgx_edac.c |   26 +++--
 drivers/edac/i82860_edac.c     |   42 ++++++---
 drivers/edac/i82875p_edac.c    |   29 ++++--
 drivers/edac/i82975x_edac.c    |   27 ++++--
 drivers/edac/mpc85xx_edac.c    |   22 +++-
 drivers/edac/mv64x60_edac.c    |   25 ++++-
 drivers/edac/pasemi_edac.c     |   25 +++--
 drivers/edac/ppc4xx_edac.c     |   25 +++--
 drivers/edac/r82600_edac.c     |   27 ++++--
 drivers/edac/sb_edac.c         |  159 ++++++++++-------------------
 drivers/edac/tile_edac.c       |   16 +++-
 drivers/edac/x38_edac.c        |   28 ++++--
 27 files changed, 800 insertions(+), 789 deletions(-)

-- 
1.7.8

