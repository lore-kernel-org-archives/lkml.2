Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0IXVIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:08:04 -0400
Received: from borg.medozas.de ([188.40.89.202]:56590 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0IXVIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:08:01 -0400
Date: Fri, 24 Sep 2010 23:08:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, jmorris@namei.org, sds@tycho.nsa.gov,
        paul.moore@hp.com, casey@schaufler-ca.com,
        linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
        mr.dash.four@googlemail.com
Subject: Re: [PATCH 5/6] conntrack: export lsm context rather than internal
 secid via netlink
In-Reply-To: <20100924204545.28355.92767.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LNX.2.01.1009242307310.3599@obet.zrqbmnf.qr>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com> <20100924204545.28355.92767.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2010-09-24 22:45, Eric Paris wrote:
>+#ifdef CONFIG_NF_CONNTRACK_SECMARK
>+static int ctnetlink_nlmsg_secctx_size(const struct nf_conn *ct)
>+{
>+	int len;
>+
>+	security_secid_to_secctx(ct->secmark, NULL, &len);
>+
>+	return sizeof(char) * len;
>+}
>+#endif

sizeof(char) is defined to be 1, so it's a little redundant.
