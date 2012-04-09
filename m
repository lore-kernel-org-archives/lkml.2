Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792Ab2DITDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 15:03:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab2DITDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 15:03:45 -0400
Date: Mon, 9 Apr 2012 21:03:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 0/1] cred: copy_process() should clear
	child->replacement_session_keyring
Message-ID: <20120409190323.GA14712@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Looks trivial, but I do not know how to test and I don't understand
this code. David, please review ;)

Note: initially this was 1/2. The usage of >replacement_session_keyring
is racy, although the problem is minor. I think that instead of fixing
a lot of key_replace_session_keyring's callers in arch/ we can add the
simple abstraction layer and kill ->replacement_session_keyring. I'll
try to send the patches tomorrow.

Btw. exit_creds() does validate_creds(cred) right before put_cred(cred),
without alter_cred_subscribers() in between this looks unneeded?

Oleg.

