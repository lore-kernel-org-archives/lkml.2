Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab2JJJ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:58:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41420 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2JJJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:58:29 -0400
MIME-Version: 1.0
Date: Wed, 10 Oct 2012 15:58:28 +0600
Message-ID: <CAEmTpZH+HhNMKp19v1ycHyeVQv+y7cuWnHqrVS4Zf4ZFSzNeMA@mail.gmail.com>
Subject: inotify: IN_IGNORED is not sent
From: =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
	<socketpair@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suppose this code:

i = inotify_init1(IN_CLOEXEC);
wd = inotify_add_watch(i, "/tmp/target2", IN_ATTRIB);
for(;;) {
    read (wd, ...);
    inotify_rm_watch(i, wd); // FAIL HERE
    wd = inotify_add_watch(i, "/tmp/target2", IN_ATTRIB);
}

Now, in shell:
$ :> /tmp/jjj
$ mv /tmp/jjj /tmp/target2

In that case IN_IGNORED is not sent, but wd previously added by
inotify_add_watch() become invalid, so, trying to call
inotify_rm_watch() failed with EINVAL.

--
Segmentation fault
