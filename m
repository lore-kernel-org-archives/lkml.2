Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0C3JmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 05:42:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48146 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3JmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 05:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=QGihrg9WvEiVbtjlAaq33mYhQ6ix/WR35RCBSluxS+tPCrzlRY13+0DJT580fJGIny
         E9Qd47HHwYa0jNPwyG4hXq9Z7rc7goLHIqG0mR+BMTMLNbLtyMQ0QtnjMTMyN3sLveop
         8wKJfEPNfA2HJqJ0EtRzQ6ZTaS611+Bgbl0v0=
Date: Tue, 30 Mar 2010 12:42:09 +0300
From: Dan Carpenter <error27@gmail.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Abhishek Kulkarni <adkulkar@umail.iu.edu>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       Latchesar Ionkov <lucho@ionkov.net>,
       Venkateswararao Jujjuri <jvrao@us.ibm.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] 9p: saving negative to unsigned char
Message-ID: <20100330094209.GI5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Abhishek Kulkarni <adkulkar@umail.iu.edu>,
	Sripathi Kodi <sripathik@in.ibm.com>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Venkateswararao Jujjuri <jvrao@us.ibm.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saving -EINVAL as unsigned char truncates the high bits and changes it 
into 234 instead of -22.  This breaks the test for "if (ret == -EINVAL)"
in parse_opts().

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/net/9p/client.c b/net/9p/client.c
index e3e5bf4..edf31aa 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -71,9 +71,10 @@ inline int p9_is_proto_dotu(struct p9_client *clnt)
 EXPORT_SYMBOL(p9_is_proto_dotu);
 
 /* Interpret mount option for protocol version */
-static unsigned char get_protocol_version(const substring_t *name)
+static int get_protocol_version(const substring_t *name)
 {
-	unsigned char version = -EINVAL;
+	int version = -EINVAL;
+
 	if (!strncmp("9p2000", name->from, name->to-name->from)) {
 		version = p9_proto_legacy;
 		P9_DPRINTK(P9_DEBUG_9P, "Protocol version: Legacy\n");
