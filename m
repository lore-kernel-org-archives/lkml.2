Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1769390Ab2K3Tbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 14:31:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:57482 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031654Ab2K3St3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:49:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 05/37] ifenslave: Fix unused variable warnings.
Date: Fri, 30 Nov 2012 10:45:52 -0800
Message-Id: <20121130183857.787200510@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130183857.166228045@linuxfoundation.org>
References: <20121130183857.166228045@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 450faacc621dbe0a4945ed8292afd45f4602d263 upstream.

Documentation/networking/ifenslave.c: In function ‘if_getconfig’:
Documentation/networking/ifenslave.c:508:14: warning: variable ‘mtu’ set but not used [-Wunused-but-set-variable]
Documentation/networking/ifenslave.c:508:6: warning: variable ‘metric’ set but not used [-Wunused-but-set-variable]

The purpose of this function is to simply print out the values
it probes, so...

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/networking/ifenslave.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/networking/ifenslave.c
+++ b/Documentation/networking/ifenslave.c
@@ -539,12 +539,14 @@ static int if_getconfig(char *ifname)
 		metric = 0;
 	} else
 		metric = ifr.ifr_metric;
+	printf("The result of SIOCGIFMETRIC is %d\n", metric);
 
 	strcpy(ifr.ifr_name, ifname);
 	if (ioctl(skfd, SIOCGIFMTU, &ifr) < 0)
 		mtu = 0;
 	else
 		mtu = ifr.ifr_mtu;
+	printf("The result of SIOCGIFMTU is %d\n", mtu);
 
 	strcpy(ifr.ifr_name, ifname);
 	if (ioctl(skfd, SIOCGIFDSTADDR, &ifr) < 0) {


