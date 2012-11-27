Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2K0AmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:42:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40105 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932495Ab2K0Al7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:41:59 -0500
Date: Mon, 26 Nov 2012 16:41:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: [patch 7/7] fs, notify: Add procfs fdinfo helper v6
Message-Id: <20121126164157.c7f86ee6.akpm@linux-foundation.org>
In-Reply-To: <20121114152239.936025193@openvz.org>
References: <20121114151937.344922058@openvz.org>
	<20121114152239.936025193@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Nov 2012 19:19:44 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> This allow us to print out fsnotify details such as
> watchee inode, device, mask and optionally a file handle.

This helps the compiler quite a lot:

--- a/fs/notify/fdinfo.c~fs-notify-add-procfs-fdinfo-helper-v7-fix
+++ a/fs/notify/fdinfo.c
@@ -26,13 +26,13 @@ static int show_fdinfo(struct seq_file *
 	struct fsnotify_mark *mark;
 	int ret = 0;
 
-	spin_lock(&group->mark_lock);
+	mutex_lock(&group->mark_mutex);
 	list_for_each_entry(mark, &group->marks_list, g_list) {
 		ret = show(m, mark);
 		if (ret)
 			break;
 	}
-	spin_unlock(&group->mark_lock);
+	mutex_unlock(&group->mark_mutex);
 	return ret;
 }
 

But I rather worry that the code which you sent clearly wasn't the code
which you tested.  Please retest and confirm that I now have the correct
code?

