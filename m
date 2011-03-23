Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab1CWVOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 17:14:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46114 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CWVON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 17:14:13 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] sparse-keymap: Emit events useful for key debugging
Date: Wed, 23 Mar 2011 16:13:41 -0500
Message-Id: <1300914823-9440-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of ACPI/WMI drivers use sparse-keymap for hotkeys. Some of the
most common hotkey problems are new keys with perviously unused scan
codes and keys that reuse scan codes for different functions than in
previous models. Diagnosis of these key problems can be done easily
from userspace as long as the drivers emit MSC_SCAN events for all keys
and KEY_UNKNOWN key events for unknown scan codes. sparse-keymap does
neither.

The following patches modify sparse-keymap to emit these events,
facilitating easier debugging of malfunctioning keys from userspace.

Thanks,
Seth


Seth Forshee (2):
  Input: sparse-keymap - report scancodes with key events
  Input: sparse-keymap - report KEY_UNKNOWN for unknown scan codes

 drivers/input/sparse-keymap.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

