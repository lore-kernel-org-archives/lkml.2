Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0GHBba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:31:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:47109 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0GHBb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:31:28 -0400
MIME-Version: 1.0
Date: Thu, 8 Jul 2010 11:31:26 +1000
Message-ID: <AANLkTimeFKvKs5fpzBXqz0PypS0YJVq6mzI0nRqo7tHg@mail.gmail.com>
Subject: IDEA: inotify - extend to be able to report changes in the past
From: Bonne Eggleston <bonne@ixum.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have an idea for an improvement to inotify, which may interest a
keen kernel developer.

The problem:
The inotify feature of the linux kernel is a great way for programs
which need to know about file changes to track them without having to
scan the drive. Unfortunately if a system is rebooted often (like
desktop and laptop machines) then the program must run a scan at
startup to check for changes since the last time it was running. This
can use a considerable amount of resources and be a deterrent from the
use of otherwise very useful programs (such as desktop search or
online backup etc.)

Potential solution:
Some modern filesystems should be able to quickly retrieve a list of
files which have changed since a certain time using the journal or
equivalent. If this was implemented within the inotify framework then
programs which use inotify could specify the timestamp when they last
ran and retrieve all the changes since that date. Inotify could then
return those change events in the usual way and possibly also a
timestamp to confirm the oldest time it was able to check back to.
This would remove the need for a scan at startup.

At this stage this is nothing more than an idea, and may well be
impossible or already implemented or already under development. In any
case I thought it worthwhile to share.

Please cc me in any responses.

Regards,
Bonne Eggleston
