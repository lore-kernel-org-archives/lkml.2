Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab0CTMao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 08:30:44 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35225 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab0CTMam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 08:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=p9l3ysur9nsulr/kNxsz5nW9ZlsN4GywheoyQ41/I40qngQOhzsRw/W/+tbyvSdZoF
         3wpI192p11rAJ8Ia4Kf5jlO7MvvIzAmBWi0r4yf0GK8MhlXGXlLCxtx9jd1ndqc5k3qx
         bSTeaKFKM7Aw2NVSaSQeh7c/TWSYv7Pm2bssY=
Date: Sat, 20 Mar 2010 15:30:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sage Weil <sage@newdream.net>
Cc: Yehuda Sadeh <yehuda@hq.newdream.net>, ceph-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] ceph: handle kmalloc() failure
Message-ID: <20100320123015.GA29929@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Sage Weil <sage@newdream.net>,
	Yehuda Sadeh <yehuda@hq.newdream.net>,
	ceph-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return ERR_PTR(-ENOMEM) if kmalloc() fails.  We handle allocation 
failures the same way later in the function.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index a260010..655b005 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -328,6 +328,8 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 	struct ceph_mds_session *s;
 
 	s = kzalloc(sizeof(*s), GFP_NOFS);
+	if (!s)
+		return ERR_PTR(-ENOMEM);
 	s->s_mdsc = mdsc;
 	s->s_mds = mds;
 	s->s_state = CEPH_MDS_SESSION_NEW;
