Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758631Ab0KOWFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 17:05:11 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:36615 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568Ab0KOWFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 17:05:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=RkUisR4v9/vpvXX2CtHkSl480gxKSjtMze7dsXJrvRGQ/j4H3sH/HzLm28qtYMnqai
         1I3La59PtTcpdUsUi+YInjUu2/5LBt+GGBCahOrwaiqZqNeZb99RQXsd2WsV5KdVDf7A
         dLXMx3snRwFrSh3NQ35RfT9/KIT2LLBu43TEo=
MIME-Version: 1.0
Date: Tue, 16 Nov 2010 01:05:09 +0300
Message-ID: <AANLkTimxbVnTVGobxhSTieJ4-PCTOZE_F6_E1-=8JcrO@mail.gmail.com>
Subject: A possible flaw in the fsnotify design.
From: Alexey Zaytsev <alexey.zaytsev@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>, linux-fsdevel@vger.kernel.org,
        "stefan@buettcher.org" <stefan@buettcher.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some thoughts.

Consider the situation: Files A and B both point to the same inode.
File A is being watched, but the user won't get notifications if B is
modified.
This might be a problem for indexers, or, in my case, backup programs.
Even if the user is watching the mont point, he still needs to get all
the possible links to the modified file, and in my understanding,
there is no way to do this without scanning the whole filesystem.

I've got no idea how to fix the problem yet, or if it would be
possible to fix at all.
