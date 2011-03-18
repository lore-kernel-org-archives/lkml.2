Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541Ab1CRRqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 13:46:42 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60626 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932493Ab1CRRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 13:46:23 -0400
From: Tony Ibbs <tibs@tonyibbs.co.uk>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 00/11] RFC: KBUS messaging subsystem
Date: Fri, 18 Mar 2011 17:21:09 +0000
Message-Id: <cover.1300450604.git.tibs@tonyibbs.co.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KBUS is a lightweight, Linux kernel mediated messaging system,
particularly intended for use in embedded environments.

It is meant to be simple to use and understand. It is designed to
provide predictable message delivery, deterministic message ordering,
and a guaranteed reply for each request. It is especially aimed at
situations where existing solutions, such as DBUS, cannot be used,
typically because of system constraints.

We have various customers using KBUS in real life, and believe it to
be useful. I had a showcase table for KBUS at the ELCE in Cambridge,
October last year, and there seemed to be interest.

The KBUS project home page is at http://kbus-messaging.org/, from
which there are links to the original Google code repository, more
documentation, and various userspace libraries.

There is a working repository with these patches applied to
Linux 2.6.37, available via:

 git pull git://github.com/crazyscot/linux-2.6-kbus.git kbus-2.6.37

These patches have been applied in branch apply-patchset-20110318

In order to keep the size of individual patches down, the main code
has been split over several patches (0004..0009). With luck this
should also make it easier to understand what KBUS is trying to do.

Tony Ibbs (11):
  Documentation for KBUS
  KBUS external header file.
  KBUS internal header file
  KBUS main source file, basic device support only
  KBUS add support for messages
  KBUS add ability to receive messages only once
  KBUS add ability to add devices at runtime
  KBUS add Replier Bind Events
  KBUS Replier Bind Event set-aside lists
  KBUS report state to userspace
  KBUS configuration and Makefile

 Documentation/Kbus.txt     | 1222 ++++++++++++
 include/linux/kbus_defns.h |  666 +++++++
 init/Kconfig               |    2 +
 ipc/Kconfig                |  117 ++
 ipc/Makefile               |    9 +
 ipc/kbus_internal.h        |  723 +++++++
 ipc/kbus_main.c            | 4690 ++++++++++++++++++++++++++++++++++++++++++++
 ipc/kbus_report.c          |  256 +++
 8 files changed, 7685 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/Kbus.txt
 create mode 100644 include/linux/kbus_defns.h
 create mode 100644 ipc/Kconfig
 create mode 100644 ipc/kbus_internal.h
 create mode 100644 ipc/kbus_main.c
 create mode 100644 ipc/kbus_report.c

-- 
1.7.4.1

