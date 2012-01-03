Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2ACQP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 11:15:28 -0500
Received: from mail.vyatta.com ([76.74.103.46]:45996 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab2ACQPY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 11:15:24 -0500
Date: Tue, 3 Jan 2012 08:15:21 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Richard Weinberger <richard@nod.at>
Cc: davem@davemloft.net, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix br_nf_pre_routing() in conjunction with
 bridge-nf-call-ip(6)tables=0
Message-ID: <20120103081521.2fec3a29@nehalam.linuxnetplumber.net>
In-Reply-To: <1325597164-13459-2-git-send-email-richard@nod.at>
References: <4F025A07.2000304@nod.at>
	<1325597164-13459-1-git-send-email-richard@nod.at>
	<1325597164-13459-2-git-send-email-richard@nod.at>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  3 Jan 2012 14:26:04 +0100
Richard Weinberger <richard@nod.at> wrote:

> If net.bridge.bridge-nf-call-iptables or net.bridge.bridge-nf-call-ip6tables
> are set to zero xt_physdev has no effect because skb->nf_bridge has not been set up.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

I am not sure if this is a valid configuration. The setting of sysctl is saying
"don't do iptables on bridge (since I won't be using it)" and then you are later
doing iptables and expecting the settings as if the iptables setup was being
done.

Instead, you should just enable the net.bridge.bridge-nf-call-iptables sysctl.
If a distro chooses to disable it then you may have to do it explicitly.

