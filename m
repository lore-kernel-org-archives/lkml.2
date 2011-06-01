Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163056Ab1FAI1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:27:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161995Ab1FAI1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:27:05 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:12 2011
Message-Id: <20110601081211.536406741@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:45 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        David Howells <dhowells@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [135/165] Set cred->user_ns in key_replace_session_keyring
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1072
Lines: 31

From: "Serge E. Hallyn" <serge@hallyn.com>

commit f7285b5d631fd6096b11c6af0058ed3a2b30ef4e upstream.

Since this cred was not created with copy_creds(), it needs to get
initialized.  Otherwise use of syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);
can lead to a NULL deref.  Thanks to Robert for finding this.

But introduced by commit 47a150edc2a ("Cache user_ns in struct cred").

Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
Reported-by: Robert Święcki <robert@swiecki.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/keys/process_keys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -845,6 +845,7 @@ void key_replace_session_keyring(void)
 	new-> sgid	= old-> sgid;
 	new->fsgid	= old->fsgid;
 	new->user	= get_uid(old->user);
+	new->user_ns	= new->user->user_ns;
 	new->group_info	= get_group_info(old->group_info);
 
 	new->securebits	= old->securebits;


