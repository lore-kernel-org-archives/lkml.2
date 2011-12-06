Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1LFStg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:49:36 -0500
Received: from mail.tpi.com ([70.99.223.143]:2237 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab1LFSte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:49:34 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>
Subject: [PATCH 0/3] TPM: CVE patch, close a race, atomic cleanup
Date: Tue,  6 Dec 2011 11:29:19 -0700
Message-Id: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes an oversight in the implementation
of CVE-2011-1162 introduced by 3321c07ae5068568cd61ac9f4ba749006a7185c9,
corrects a race between readers and writers, and cleans up the
use of an unnecessary atomic variable.

Tim Gardner (3):
  TPM: Zero buffer whole after copying to userspace
  TPM: Close data_pending and data_buffer races
  TPM: data_pending is no longer atomic

 drivers/char/tpm/tpm.c |   28 +++++++++++++++-------------
 drivers/char/tpm/tpm.h |    2 +-
 2 files changed, 16 insertions(+), 14 deletions(-)

