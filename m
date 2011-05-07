Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab1EGCXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 22:23:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34074 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab1EGCXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 22:23:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-arch@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, jamal <hadi@cyberus.ca>,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linux Containers <containers@lists.osdl.org>,
        Renato Westphal <renatowestphal@gmail.com>
Subject: [PATCH 0/7] Network namespace manipulation with file descriptors
Date: Fri, 06 May 2011 19:23:29 -0700
Message-ID: <m1tyd7p7tq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+H8uMe2kAx6snZESPZNatP322IcfNY/ks=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today there are something things you can use namespaces to implement but
the userspace code is unnecessarily complex and fragile because of
limitations of the kernel interfaces.

This patchset addresses the user interface limitations by introducing
proc files you can open to get file descriptors that keep alive and
refer to your a tasks namespaces.  Those file descriptors can be passed
to the new setns system call or the NET_NS_FD argument in netlink
messages.

This patchset is sufficient to implement linux support for named network
namespaces in iproute allowing vpns to be isolated in a network
namespace where you don't have to worry about them conflicting with the
rest of your network.

This patchset is almost sufficient to remove the need for a daemon in a
container to allow you to log in.  Unfortunately a few of the namespaces
are not ready to merge yet so I have left them out.

Arch maintainers could you look over patch 7 and verify I have wired
up this new system call correctly.

These changes are also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/linux-2.6-nsfd.git

