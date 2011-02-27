Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1B0XRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:17:36 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46606
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751794Ab1B0XRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:17:34 -0500
Date: Sun, 27 Feb 2011 15:18:10 -0800 (PST)
Message-Id: <20110227.151810.246542623.davem@davemloft.net>
To: segoon@openwall.com
Cc: bhutchings@solarflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
        jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net,
        eric.dumazet@gmail.com, therbert@google.com, xiaosuo@gmail.com,
        jesse@nicira.com, kees.cook@canonical.com, eugene@redhat.com,
        dan.j.rosenberg@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] don't allow CAP_NET_ADMIN to load non-netdev kernel
 modules
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110227114438.GA4317@albatros>
References: <1298660879.2554.23.camel@bwh-desktop>
	<20110225.111606.115927805.davem@davemloft.net>
	<20110227114438.GA4317@albatros>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segoon@openwall.com>
Date: Sun, 27 Feb 2011 14:44:38 +0300

>    d) run modprobe with CAP_NET_ADMIN only

This is not part of my scheme.

The module loading will run with existing module loading privileges,
the "allowed capability" bits will be passed along back into the
kernel at module load time (via modprobe arguments or similar)
and validated by the kernel as it walks the ELF sections anyways
to perform relocations and whatnot.

