Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0HKSwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:52:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41261 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab0HKSwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:52:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=XO2nNdM94fzQx4iOEJbAHfjcntf28iVvaPtoaWKkKZ3z7SFHgG4Ox3EV2QhyRt4OJN
         11WbRKjfpPNeBauD6qcb/NQVgWj7r7LOCLZbs9E3yxGIOKLbHkHDnSa/3GDmQEZw9Ogt
         e6Ft97ZLVXKovfPBWSAN5WZl7G5YXb9+LKPzs=
Date: Wed, 11 Aug 2010 20:51:28 +0200
From: Dan Carpenter <error27@gmail.com>
To: eparis@redhat.com
Cc: linux-kernel@vger.kernel.org
Subject: re: fsnotify: pass both the vfsmount mark and inode mark
Message-ID: <20100811185128.GC645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>, eparis@redhat.com,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a NULL dereference introduced in ce8f76fb7320 "fsnotify: pass
both the vfsmount mark and inode mark"

   143  static int send_to_group(struct inode *to_tell, struct vfsmount *mnt,
   144                           struct fsnotify_mark *inode_mark,
   145                           struct fsnotify_mark *vfsmount_mark,
   146                           __u32 mask, void *data,
   147                           int data_is, u32 cookie,
   148                           const unsigned char *file_name,
   149                           struct fsnotify_event **event)
   150  {
   151          struct fsnotify_group *group = inode_mark->group;
                                               ^^^^^^^^^^^^^^^^^^
	inode_mark can be NULL.

   152          __u32 inode_test_mask = (mask & ~FS_EVENT_ON_CHILD);
   153          __u32 vfsmount_test_mask = (mask & ~FS_EVENT_ON_CHILD);

I'm not sure how to handle this.

regards,
dan carpenter
