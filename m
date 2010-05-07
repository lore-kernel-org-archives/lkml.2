Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0EGQ5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 12:57:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab0EGQ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 12:57:14 -0400
Subject: Re: fanotify issues in 2.6.34-rc6-next-20100506
From: Eric Paris <eparis@redhat.com>
To: Anders Blomdell <anders.blomdell@control.lth.se>
Cc: Eric Paris <eparis@parisplace.org>, linux-kernel@vger.kernel.org
In-Reply-To: <4BE3DC60.7080105@control.lth.se>
References: <4BE3DC60.7080105@control.lth.se>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 May 2010 12:57:01 -0400
Message-ID: <1273251421.15368.208.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 11:24 +0200, Anders Blomdell wrote:

> seems to lose/corrupt events. For instance running 'fanotify -c /dir/to/watch'
> and then running the command 'cd /dir/to/watch ; touch a b c d e f g h i j k l'
>  might generate (results are more or less random):

sometimes I'm not the sharpest knife in the drawer.  switch statements
are hard.

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index bbcfccd..34c9661 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -21,6 +21,7 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;
+			break;
 		case (FSNOTIFY_EVENT_NONE):
 			return true;
 		default:


