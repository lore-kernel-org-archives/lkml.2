Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1EVJCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 05:02:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45556 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1EVJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 05:02:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:sender:from:date:x-google-sender-auth
         :message-id:subject:to:cc:content-type;
        b=viHesIntl3HfVmR9pXHQd3qTZQIvAFdZo605kb26xxxQCNyg4fdWwCGlPR9dqyMjsh
         qoYRnshMqNi3FHK8GDjYCSPHPriLez+ZLXFnaFJSoZIsQOJnTZj8qXBFa2n7wy9I1AjL
         sThbfuYGd+OUtgiDpxwAx9d+MdEQB+GQ9Bchw=
MIME-Version: 1.0
Reply-To: d.g.jansen@googlemail.com
From: Dennis Jansen <Dennis.Jansen@web.de>
Date: Sun, 22 May 2011 11:01:57 +0200
X-Google-Sender-Auth: 3mqmPq7j5W-KPRxETcrSiEZUlns
Message-ID: <BANLkTikXpjCpTPDsk2cff-p0cmu69kAg3g@mail.gmail.com>
Subject: Response Summary Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So just to summarize - correct me if I'm wrong:

There is general opposition to the idea of disabling fsync:
- whether automatically while in laptop mode or by user's choice, e.g.
via a special setting
- no matter what the fsync call would return - whether any error code or success
-> at all and in any form or context
in kernel space.

The reason seems to be mainly:
 - data security (esp. destruction of existing data in case of
ordering problems)
 - application compatibility (e.g. mailserver able to work according
to standards)
 - misuse potential (users not knowing what they're doing and/or how)
 - "Changing a generic, widely used kernel option"

There is a general distinction made between using laptop mode ("soft"
increased data loss risk) and disabling fsync (not providing a
guaranteed write when specificly asked for it).

There is no agreement:
- whether ordering guarantees would be an issue (in a "properly
implemented filesystem").

There was no response to:
- whether something like featherstick
(http://lwn.net/Articles/354861/) would make sense (in kernel space)
in this context.
- flame war suggestions ;)

The proposed solution is:
- to implement this in user space.

Thanks for everyone for their feedback!
