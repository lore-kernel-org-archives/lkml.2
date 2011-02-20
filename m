Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1BTQxv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 11:53:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61256 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1BTQxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 11:53:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JHvgSXE2PmHI/LyINjA+eESxblRJ+jKZoILdSYaxT1VQqKFpeMnFkDMJljqsisNfBT
         wCm3lgWd6A9oBza22hwuR45MAZDvPmFEr8dkeQwiDj02YGEN2FgRYYydN7mjougQ/nP0
         zhWSBfMYz4jMqS0g6G68wjWs8MuSZoAkeP6BE=
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>, Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 0/2] Staging: xgifb: Remove CRIT[FLAGS | BEGIN | END] defines nd conditional spinlock compilation logic
Date: Sun, 20 Feb 2011 17:53:16 +0100
Message-Id: <1298220798-2942-1-git-send-email-martinez.javier@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xgifb staging driver uses a set of defines that hides the synchronization
mechanism used to access critical sections. Also, the use of spinlocks
can be disabled in compile time.

Since the spinlocks ABI only are used in contexts were critical section exists
(UP with preemption enabled and SMP machines), I think we should always have
the spinlocks enabled and let the spinlock ABI choose to include the spinlocks
or not. In the other hand if the driver doesn't need locking at all, then
maybe we should just delete the spinlock logic.

This patchset first replaces all the defines used with explicit definitions,
then removes all the defines and the spinlocks optional compilation logic.

The patchset is composed of the following patches:

[PATCH 1/2] Staging: xgifb: Remove CRIT[FLAGS | BEGIN | END] defines usage
[PATCH 2/2] Staging: xgifb: Removes CRIT[FLAGS | BEGIN | END] defines and conditional spinlock compilation logic
