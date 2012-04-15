Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab2DOL6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 07:58:49 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:55913
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1752966Ab2DOL6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 07:58:47 -0400
Date: Sun, 15 Apr 2012 13:58:39 +0200 (CEST)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: mtdchar kernel oops
Message-ID: <alpine.DEB.2.00.1204151350450.13924@eristoteles.iwoars.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that this patch:
"mtdchar: kill persistently held vfsmount"
http://permalink.gmane.org/gmane.linux.kernel.commits.head/314175

has started causing kernel oops's when running ubiformat. The oops is
occuring in fs/namespace.c's mnt_add_count() line:
        this_cpu_add(mnt->mnt_pcp->mnt_count, n);

with the stack trace:
mntget()
simple_pin_fs()
mtdchar_open()

Cheers,
Joel
