Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab2LRBP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:15:56 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:39678 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab2LRBPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:15:55 -0500
X-Greylist: delayed 1136 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 20:15:55 EST
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 17 Dec 2012 17:10:21 -0800
Message-ID: <CALCETrXs15M-cJRGD_R7fXBxOXR=Pyqsh2dVC78DgShxwn60nA@mail.gmail.com>
Subject: Are there u32 atomic bitops? (or dealing w/ i_flags)
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to change inode->i_flags access to be atomic -- there are some
locking oddities right now, I think, and I want to use a new inode
flag to signal mtime updates from page_mkwrite.  The problem is that
i_flags is an unsigned int, and making it an unsigned long seems like
a waste, but there aren't any u32 atomic bitops.

What should I do?  Suck it up and waste four bytes on 64-bit machines?

In general, having atomic flag words be long seems likely to waste
bits on 64-bit architectures.

--Andy
