Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2BJKDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 05:03:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39325 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758633Ab2BJKDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 05:03:06 -0500
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, mpatocka@redhat.com,
        Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 0/2 v2] Fix deadlock with suspend & quotas
Date: Fri, 10 Feb 2012 11:02:59 +0100
Message-Id: <1328868181-16979-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello Al,

  This is my attempt to fix deadlock in quota code when filesystem is
suspended and someone tries to modify quota e.g. via Q_SETQUOTA command. I
added a VFS function to get a superblock reference and return only after
the filesystem is thawed.

Changes since v1:
* wait for frozen fs really only when requested
* updated some comments & names

								Honza
