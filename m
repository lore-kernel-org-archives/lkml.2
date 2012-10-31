Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2JaHKO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 03:10:14 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44188 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab2JaHKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 03:10:06 -0400
Date: Wed, 31 Oct 2012 10:10:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org, smatch@vger.kernel.org,
        Ed Cashin <ecashin@coraid.com>
Subject: Smatch 1.57 released
Message-ID: <20121031071005.GE6667@mwanda>
References: <8D458972-B1BB-4BB2-8C91-3489A8D24428@coraid.com>
 <20121030175330.GD6667@mwanda>
 <A607CE07-5C1C-445B-B2CA-DA3B25237F5E@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A607CE07-5C1C-445B-B2CA-DA3B25237F5E@coraid.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch is a C static analysis tool, but with a lot of kernel
specific checks.  It's been 8 months since I did a Smatch release so
probably another one was due.

The main interesting thing right now is the value tracking across
function boundaries with the database.  But also there was a some
work done with array out of bounds detection.  And internally there
was a fix so it should run faster and use less memory.  Along with
lots of other small fixes.

The way to use Smatch is:
	git clone git://repo.or.cz/smatch.git
	cd smatch
	make
	cd ~/path/to/kernel

	[ This next step is optional if you want to build the
	  database.  If you build it several times the database
	  becomes more complete. ]
	~/path/to/smatch/smatch_scripts/build_kernel_data.sh

	~/path/to/smatch/smatch_scripts/test_kernel.sh

It creates warns.txt file with all the warnings.  Or alternatively
if you just want to check one file then the command is:

	~/progs/smatch/devel/smatch_scripts/kchecker drivers/file.c

regards,
dan carpenter
