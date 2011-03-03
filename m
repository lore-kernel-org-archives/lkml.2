Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab1CCOnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 09:43:41 -0500
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:65311 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757859Ab1CCOnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 09:43:40 -0500
X-AuditID: 12074423-b7bd0ae000000a00-7d-4d6fa91b80d7
Subject: Re: [RFC] st_nlink after rmdir() and rename()
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20110303032454.GI22723@ZenIV.linux.org.uk>
Date: Thu, 3 Mar 2011 09:34:08 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <406B4874-D3D8-4C05-9FA5-8A7A18ABF89C@mit.edu>
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
X-Mailer: Apple Mail (2.1082)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 2, 2011, at 10:24 PM, Al Viro wrote:

> We have an interesting problem.  Consider the following sequence
> of syscalls:
> 	mkdir("foo", 0777);
> 	mkdir("bar", 0777);
> 	fd1 = open("foo", O_DIRECTORY);
> 	fd2 = open("bar", O_DIRECTORY);
> 	rename("foo", "bar");	/* kill old bar */

I must be missing something.  I didn't think you could rename on
top of a directory and have the directory disappear.  Don't you get
an error in that case?  What happens if bar contains files?

We don't allow:  mkdir("bar", 0777); unlink("bar");

Why should this be any different?

-- Ted

