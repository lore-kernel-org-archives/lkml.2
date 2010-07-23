Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0GWKto (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 06:49:44 -0400
Received: from stinky.trash.net ([213.144.137.162]:35209 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0GWKtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 06:49:42 -0400
Message-ID: <4C4973C3.5060409@trash.net>
Date: Fri, 23 Jul 2010 12:49:39 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Malcolm Turnbull <malcolm@loadbalancer.org>,
        Mark Brooks <mark@loadbalancer.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Julius Volz <julius.volz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hannes Eder <heder@google.com>, Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch v2.8 3/4] IPVS: make FTP work with full NAT support
References: <20100722073547.504156161@vergenet.net> <20100722075012.950341908@vergenet.net>
In-Reply-To: <20100722075012.950341908@vergenet.net>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2010 09:35, schrieb Simon Horman:
> From:	Hannes Eder <heder@google.com>
> 
> Use nf_conntrack/nf_nat code to do the packet mangling and the TCP
> sequence adjusting.  The function 'ip_vs_skb_replace' is now dead
> code, so it is removed.
> 
> To SNAT FTP, use something like:
> 
> % iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 \
>> --vport 21 -j SNAT --to-source 192.168.10.10
> 
> and for the data connections in passive mode:
> 
> % iptables -t nat -A POSTROUTING -m ipvs --vaddr 192.168.100.30/32 \
>> --vportctl 21 -j SNAT --to-source 192.168.10.10
> 
> using '-m state --state RELATED' would also works.
> 
> Make sure the kernel modules ip_vs_ftp, nf_conntrack_ftp, and
> nf_nat_ftp are loaded.
> 

Applied, thanks.
