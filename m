Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1KAXv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:51:27 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52221 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab1KAXv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:51:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:organization:x-system-of-record;
	b=ZkMiPWhJy57c2QIMQPtwjP9GUSwHOsE8S6TMVVsyZzB7zvSiNk/1eJ67zR1KdDTNW
	YZtT3u87ktQxwHY+BBTrw==
From: David Decotigny <david.decotigny@google.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Michal Schmidt <mschmidt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dmitry Torokhov <dtor@vmware.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Satoru Moriya <satoru.moriya@hds.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH v2 0/3] param: optional /sys/module/*/parameters
Date: Tue,  1 Nov 2011 16:50:32 -0700
Message-Id: <cover.1320191327.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
Organization: Google, Inc.
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thank you Rusty for your review.

Here is the v2. I hope it is easier to understand. It also adds
doc for the new Kconfig knob.

Description:

  These patches turn /sys/module/*/parameters into an optional feature
  that can be enabled/disabled at compilation time. The goal is to
  encourage module developers to expose more of their parameters with
  fewer hesitations (eg. memory concerns, etc.), as the burden on
  small systems can now be avoided by disabling
  /sys/module/*/paramaters/ altogether at compile-time. On larger
  systems, having more module parameters exposed would help
  debugging/auditing of live systems.

Regards,


############################################
# Patch Set Summary:

David Decotigny (3):
  param: make destroy_params() private
  param: simple refactoring
  param: make /sys/module/*/paramaters optional

 Documentation/ABI/stable/sysfs-module |    3 +
 Documentation/DocBook/kgdb.tmpl       |    3 +-
 fs/sysfs/Kconfig                      |   15 ++++-
 include/linux/moduleparam.h           |   14 +----
 kernel/module.c                       |    9 +++
 kernel/params.c                       |  108 ++++++++++++++++-----------------
 6 files changed, 82 insertions(+), 70 deletions(-)

-- 
1.7.3.1

