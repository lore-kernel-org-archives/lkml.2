Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2FDBzJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:55:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:48346 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462Ab2FDBzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:55:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: JohnG <jhnlmn@yahoo.com>
Subject: Re: fanotify issues in 2.6.34-rc6-next-20100506
Date: Mon, 4 Jun 2012 01:49:17 +0000 (UTC)
Message-ID: <loom.20120604T034814-206@post.gmane.org>
References: <4BE3DC60.7080105@control.lth.se> <1273251421.15368.208.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 64.81.73.85 (Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20100101 Firefox/10.0.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2010-05-07 at 11:24 +0200, Anders Blomdell wrote:
> ... switch statements are hard.

Two years passed, but this patch was never applied
and fanotify is as broken as it has been.
So, two questions:
- does anyone going to finally apply that patch (add "break" before case
(FSNOTIFY_EVENT_NONE) in should_merge)
- what is the status of fanotify? Does anybody still use it? Does it work (aside
from this bug?)

Just in case, I copied that old patch below:


diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index bbcfccd..34c9661 100644
a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -21,6 +21,7 @@ static bool should_merge(struct fsnotify_event *old, struct
fsnotify_event *new)
if ((old->path.mnt == new->path.mnt) &&
(old->path.dentry == new->path.dentry))
return true;
+ break;
case (FSNOTIFY_EVENT_NONE):
return true;
default:


