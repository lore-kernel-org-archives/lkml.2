Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2CEQjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:39:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20606 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2CEQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:39:29 -0500
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=drOt6m5kAAAA:8 a=ZJw6W0DUovJAQazLhPsA:9 a=PUjeQqilurYA:10 a=zT2tiyAo1x9qkYWv:21 a=C8ficjdVkNSXY1P7:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1330965566.25686.327.camel@gandalf.stny.rr.com>
Subject: Missing stable commits?
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 05 Mar 2012 11:39:26 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I'm going through adding commits from Thomas's latest -rt patch set
into the stable-rt tree, some of the patches conflicted. Looking at the
conflicts, it seems that mainline has patches that should probably be
added to the stable tree. Here's what I found so far:

commit 1b71fe2efa31cd18c865db474a4cd473b6ab5281
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Jul 16 23:43:58 2011 -0400

    ceph analog of cifs build_path_from_dentry() race fix
    
    ... unfortunately, cifs bug got copied.  Fix is essentially the same.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit dc137bf553dbb6855bd7efc34fedcd03102455f7
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Jul 16 23:37:20 2011 -0400

    cifs: build_path_from_dentry() race fix
    
    deal with d_move() races properly; rename_lock read-retry loop,
    rcu_read_lock() held while walking to root, d_lock held over
    subtraction from namelen and copying the component to stabilize
    ->d_name.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>


These seem appropriate for stable, don't they?

-- Steve


