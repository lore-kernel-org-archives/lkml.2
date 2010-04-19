Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab0DSW2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 18:28:55 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.153.193]:43684 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0DSW2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 18:28:54 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2010 18:28:54 EDT
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [PATCH] fcntl.h: define AT_EACCESS
Date: Mon, 19 Apr 2010 22:20:13 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <hqikut$4ts$1@taverner.cs.berkeley.edu>
References: <1271387280-19565-1-git-send-email-max@stro.at> <20100419144729.2b8180e8.akpm@linux-foundation.org> <20100419215711.GR10984@baikonur.stro.at>
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1271715613 5052 128.32.153.193 (19 Apr 2010 22:20:13 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 19 Apr 2010 22:20:13 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you share some justification why it's worth extending
faccessat() with new options?

Isn't faccessat() insecure in most use cases, due to TOCTTOU
(time-of-check to time-of-use) vulnerabilities?  When faccessat()
returns 0, you learn that at some point in the past, the process had
permission to access a given file, though the process may or may not
have permission at the moment.  Why is that a useful thing to know?

I'm sure you're familiar with all the standard arguments why using
access() tends to represent a security vulnerability.  Is there a reason
why similar arguments do not apply to faccessat()?
