Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab1KROgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:36:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757937Ab1KROgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:36:52 -0500
Message-ID: <4EC66D7B.7030908@RedHat.com>
Date: Fri, 18 Nov 2011 09:36:43 -0500
From: Steve Dickson <SteveD@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: David Howells <dhowells@redhat.com>, jmorris@redhat.com,
        keyrings@linux-nfs.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Keyrings] [PATCH] KEYS: Allow special keyrings to be cleared
References: <20111111160753.5190.36069.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111111160753.5190.36069.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Trond,

Could you please add this patch to David's patch set?

tia,

steved.

Author: Steve Dickson <steved@redhat.com>
Date:   Fri Nov 18 09:29:17 2011 -0500

    KEYS: allow keys to be revoked from the keyring
    
    To aid in cleaning up invalid id mappings add
    the write bit to the key permission. Allowing
    only root will be able to revoke the keys.
    
    Signed-off-by: Steve Dickson <steved@redhat.com>

diff --git a/fs/nfs/idmap.c b/fs/nfs/idmap.c
index 47d1c6f..652238c 100644
--- a/fs/nfs/idmap.c
+++ b/fs/nfs/idmap.c
@@ -185,7 +185,7 @@ static ssize_t nfs_idmap_request_key(const char *name, size_t nam
        }
 
        rcu_read_lock();
-       rkey->perm |= KEY_USR_VIEW;
+       rkey->perm |= KEY_USR_VIEW|KEY_USR_WRITE;
 
        ret = key_validate(rkey);
        if (ret < 0)

