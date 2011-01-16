Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1APRzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 12:55:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51840 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab1APRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 12:55:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=RncEHa41EXMNSJ2oiiVwOih+jUEUog/0zlz04ujGe3rHzuqOCFvildAmL0eu5f/bTs
         prLEwK0D1Q97Nueo8ZITUFwr6VV3g9QyfaoaNJMq/mArQT1wKUwahy2w39C6DFun26mh
         F47D+3zpBlLosoMNRJw6FXWRDcPQdG4aFnrnw=
MIME-Version: 1.0
Date: Sun, 16 Jan 2011 19:55:31 +0200
X-Google-Sender-Auth: mps9iqoi3NEYanuuThh-EL1KDdo
Message-ID: <AANLkTinqnX30+oNYMAmcWiSssqQTOq+s4Gnb8fUWdKSa@mail.gmail.com>
Subject: WARN_ON_ONCE() in mark_buffer_dirty() being triggered during ext2
 umount of an 'errored' block device
From: Dan Aloni <dan@aloni.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

With a block device driver that I've implemented, I noticed that if
the block device is in an error state (i.e. all requests return
immediately with an error), and I invoke umount on an ext2 file system
mount on that block device, I get an unexpected kernel stack dump.

The relevant bits of the stack dump show that umount indirectly calls
mark_buffer_dirty(), and then the WARN_ON_ONCE(!buffer_uptodate(bh))
in mark_buffer_dirty() is triggered. I've seen this behavior with ext2
but did not test other file systems.

Now, I suspect this problem has something to do with
end_buffer_async_write() calling clear_buffer_uptodate(bh) but I'm no
VFS expert. The kernel is based on 2.6.32.12 but the code I'm talking
about seems to apply to latest as well.

Or - is it possible that I've mis-implemented the block device driver?

Thanks,
- Dan
