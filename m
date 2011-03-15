Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757642Ab1COMgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:36:37 -0400
Received: from stinky.trash.net ([213.144.137.162]:42437 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab1COMge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:36:34 -0400
Message-ID: <4D7F5D4F.7030703@trash.net>
Date: Tue, 15 Mar 2011 13:36:31 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100620 Icedove/3.0.5
MIME-Version: 1.0
To: Vasiliy Kulikov <segoon@openwall.com>
CC: linux-kernel@vger.kernel.org, security@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ipv4: netfilter: ip_tables: fix infoleak to userspace
References: <1299780735-32607-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1299780735-32607-1-git-send-email-segoon@openwall.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.03.2011 19:12, Vasiliy Kulikov wrote:
> Structures ipt_replace, compat_ipt_replace, and xt_get_revision are
> copied from userspace.  Fields of these structs that are
> zero-terminated strings are not checked.  When they are used as argument
> to a format string containing "%s" in request_module(), some sensitive
> information is leaked to userspace via argument of spawned modprobe
> process.
> 
> The first and the third bugs were introduced before the git epoch; the
> second was introduced in 2722971c (v2.6.17-rc1).  To trigger the bug
> one should have CAP_NET_ADMIN.

Applied, thanks.
