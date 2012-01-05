Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab2AETuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:50:51 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:51516 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504Ab2AETuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:50:50 -0500
Message-ID: <4F05FF15.5010809@pandora.be>
Date: Thu, 05 Jan 2012 20:50:45 +0100
From: Bart De Schuymer <bdschuym@pandora.be>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Stephen Hemminger <shemminger@vyatta.com>, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix br_nf_pre_routing() in conjunction with
 bridge-nf-call-ip(6)tables=0
References: <4F025A07.2000304@nod.at> <1325597164-13459-1-git-send-email-richard@nod.at> <1325597164-13459-2-git-send-email-richard@nod.at> <20120103081521.2fec3a29@nehalam.linuxnetplumber.net> <4F033E11.5060707@nod.at> <4F0361D7.3000602@pandora.be> <4F03650D.8050200@nod.at> <4F049290.3090803@pandora.be> <4F04DD19.601@nod.at>
In-Reply-To: <4F04DD19.601@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 120105-1, 05/01/2012), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 5/01/2012 0:13, Richard Weinberger schreef:
>
> Let's export brnf_call_iptables and brnf_call_ip6tables, such that
> physdev_mt_check() can notify the user that his iptables rule will have
> no effect.
>

I don't want to introduce a runtime dependency between the iptables 
physdev module and the bridge module.
This should keep working:
#modprobe bridge
#modprobe xt_physdev
#rmmod bridge
It will stop working if you use exported symbols of the bridge module in 
the physdev module.

Bart

-- 
Bart De Schuymer
www.artinalgorithms.be

