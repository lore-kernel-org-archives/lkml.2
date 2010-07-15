Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab0GOPYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:24:36 -0400
Received: from stinky.trash.net ([213.144.137.162]:46933 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab0GOPYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:24:35 -0400
Message-ID: <4C3F282F.3010006@trash.net>
Date: Thu, 15 Jul 2010 17:24:31 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "Daniel P. Berrange" <berrange@redhat.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jan Engelhardt <jengelh@medozas.de>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCHv4] extensions: libxt_CHECKSUM extension
References: <20100715115229.GB6737@redhat.com>
In-Reply-To: <20100715115229.GB6737@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.07.2010 13:52, schrieb Michael S. Tsirkin:
> This adds a `CHECKSUM' target, which can be used in the iptables mangle
> table.
> 
> You can use this target to compute and fill in the checksum in
> a packet that lacks a checksum.  This is particularly useful,
> if you need to work around old applications such as dhcp clients,
> that do not work well with checksum offloads, but don't want to disable
> checksum offload in your device.
> 
> The problem happens in the field with virtualized applications.
> For reference, see Red Hat bz 605555, as well as
> http://www.spinics.net/lists/kvm/msg37660.html
> 
> Typical expected use (helps old dhclient binary running in a VM):
> iptables -A POSTROUTING -t mangle -p udp --dport bootpc \
> -j CHECKSUM --checksum-fill

Applied to iptables-next, thanks.
