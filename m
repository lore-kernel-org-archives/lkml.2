Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1F1HMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 03:12:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63504 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1F1HKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 03:10:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Ol6YZz7rVYuO7NIYdQFe99hindRNN6U0hCcD8DnuRIrP8g70aj83z8PXq4bWeO6VfS
         1to5oSrnEUU7zc675yBBzQ4hzTKa6lF039vjbJ1EijjZZ2MbtHJtpiTZEpvNnMhYG0PW
         MMu3wCVOGFVEcmjD1XyjDfGEOMHwSsLJOrjKc=
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gnb@fmeh.org, jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de
Subject: [PATCH 0/11] dynamic_debug: allow multiple pending queries on boot-line
Date: Tue, 28 Jun 2011 01:09:41 -0600
Message-Id: <1309244992-2305-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset extends dynamic-debug facility to allow 
use of pr_debug() within a loadable module's module_init() 
function.  Query/rules can be given on the boot-line,
and are saved to a pending list if they cannot be applied
immediately.  Later, when the module is being loaded, the
pending list is scanned, and matching rules are applied.
Thus pr_debug() calls in the module's initialization function
are active when it is invoked.

Other features:
- dynamic_debug.verbose=1 at boot-time or while running
- ddebug_query can specify multiple queries, separated by ';'
- warn on multiple uses of a single match-spec in single query
- tolerate bad queries in ddebug_query w/o taking down facility

Possible additions (not done now)

- <dbgfs>/dynamic_debug/pending
  to show pending query/rules

- scan existing pending list before adding new entry
  currently same rule can be appended multiple times

- persistent queries
  when module is unloaded, applied rules are deleted


[PATCH 01/11] dynamic_debug: allow changing of dynamic_debug verbosity any time
[PATCH 02/11] dynamic_debug: trim source-path prefix from dynamic_debug/control
[PATCH 03/11] dynamic_debug: process multiple commands on a line
[PATCH 04/11] dynamic_debug: warn when >1 of each type of match-spec is given
[PATCH 05/11] dynamic_debug: use pr_info instead of printk(KERN_INFO ..
[PATCH 06/11] dynamic_debug: KERN_ERR should not depend upon verbosity
[PATCH 07/11] dynamic_debug: dont kill entire facility on error parsing ddebug_query
[PATCH 08/11] dynamic_debug: return int from ddebug_change
[PATCH 09/11] dynamic_debug: add_to_pending() saves non-matching queries for later.
[PATCH 10/11] dynamic_debug: call apply_pending_queries from ddebug_add_module
[PATCH 11/11] dynamic_debug: document use of pendinq queries at boot-time
