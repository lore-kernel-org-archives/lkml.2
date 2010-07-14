Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257Ab0GNGMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 02:12:23 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:56685 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751248Ab0GNGMU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 02:12:20 -0400
X-AuditID: 1209190d-b7c19ae0000009ea-5d-4c3d5543d6ba
Subject: Re: emacs and "linux" coding style
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <20100713151902.ca37fc2b.rdunlap@xenotime.net>
Date: Wed, 14 Jul 2010 02:12:13 -0400
Cc: Dimitrios Apostolou <jimis@gmx.net>, linux-kernel@vger.kernel.org,
        Dan Nicolaescu <dann@gnu.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0A4C5074-D482-42EE-98D1-93C636BC80B8@mit.edu>
References: <alpine.LNX.2.00.1007131644180.1500@localhost.localdomain> <20100713151902.ca37fc2b.rdunlap@xenotime.net>
To: Randy Dunlap <rdunlap@xenotime.net>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 13, 2010, at 6:19 PM, Randy Dunlap wrote:
> 
> See CodingStyle, Chapter 1, Indentation:
> 
> "Outside of comments, documentation and except in Kconfig, spaces are never
> used for indentation, and the above example is deliberately broken."
> 
> which to me means "spaces alone are never used (unless the indentation is less than
> 8 columns)".

There is a huge amount of code --- including code which I submitted
back in the 0.12 days of Linux --- which uses spaces to align continuation
lines for function parameters, i.e.

static int foo(struct inode inode, struct file *file, int flags,
		       size_t len)

such that "struct" and "size_t" are aligned on the same column, and also so that:

	unsigned int num = ((len + sizeof(struct foobaz) - 3) /
					     (4 + sizeof(struct foobaz)));

I've always read indentation as referring to indentation for the beginning of
code lines, but not to making function parameters or paraenthesis line
up.   This is something which emacs does automatically, but vi does not.

People who are anal enough to worry about this sort of thing, in general,
IMHO, really should find better things to do.   And if checkpatch.pl were to
be "improved" to start issue warnings about code not adhering to this 
CodingStyle assertion, #1, you would find out how much code doesn't 
adhere to this, and #2, I think a lot of people, including myself, would be
complaining vociferously and agitating to have that language removed
from CodingStyle as being an actively harmful and incorrect recommendation.

-- Ted


