Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1GLXiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 19:38:05 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:58739 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754284Ab1GLXhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 19:37:45 -0400
From: Serge Hallyn <serge@hallyn.com>
To: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Cc: dhowells@redhat.com, ebiederm@xmission.com
Subject: [RFC PATCH 0/14] user namespaces: continue targetting capabilities
Date: Tue, 12 Jul 2011 23:30:38 +0000
Message-Id: <1310513452-13397-1-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is a set of patches to continue targetting capabilities
where appropriate.  This set goes about as far as is possible
without making the VFS user namespace aware, meaning that the
VFS can provide a namespaced view of userids, i.e init_user_ns
sees file owner 500, while child user ns sees file owner 0 or
1000.

With this set applied, you can create and configure veth netdevs
if your user namespace owns your network namespace (and you are
privileged), but not otherwise.

Some simple testcases can be found at
https://code.launchpad.net/~serge-hallyn/+junk/usernstests with
packages at https://launchpad.net/~serge-hallyn/+archive/userns-natty

Feedback very much appreciated.

