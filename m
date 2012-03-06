Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965188Ab2CFSvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 13:51:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965074Ab2CFSvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 13:51:41 -0500
Date: Tue, 6 Mar 2012 13:51:37 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Fedora Kernel Team <kernel-team@fedoraproject.org>,
        viro@ZenIV.linux.org.uk
Subject: inode->i_wb_list corruption.
Message-ID: <20120306185137.GA15881@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	viro@ZenIV.linux.org.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've had three separate reports against 3.2.x recently where the linked list debugging
is getting tripped up by the prev->next pointer being null instead of pointing
to the current list entry while walking the i_wb_list

Call traces are slightly different each time, but all end up walking i_wb_list 
in dput -> d_kill -> i_put -> evict -> inode_wb_list_del

What protects that list ? It looks to be just bdi->wb.list_lock ?


full reports at:
https://bugzilla.redhat.com/show_bug.cgi?id=784741
https://bugzilla.redhat.com/show_bug.cgi?id=799229
https://bugzilla.redhat.com/show_bug.cgi?id=799692

	Dave

