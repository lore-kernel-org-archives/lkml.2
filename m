Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578Ab0GOPRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:17:52 -0400
Received: from stinky.trash.net ([213.144.137.162]:46783 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab0GOPRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:17:50 -0400
Message-ID: <4C3F268E.8050405@trash.net>
Date: Thu, 15 Jul 2010 17:17:34 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, herbert.xu@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] netfilter: add CHECKSUM target
References: <20100708222913.GA4475@redhat.com> <4C373D90.8070000@trash.net> <20100711104705.GA18017@redhat.com>
In-Reply-To: <20100711104705.GA18017@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.07.2010 12:47, schrieb Michael S. Tsirkin:
> On Fri, Jul 09, 2010 at 05:17:36PM +0200, Patrick McHardy wrote:
>> Am 09.07.2010 00:29, schrieb Michael S. Tsirkin:
>>> This adds a `CHECKSUM' target, which can be used in the iptables mangle
>>> table.
>>>
>>> You can use this target to compute and fill in the checksum in
>>> an IP packet that lacks a checksum.  This is particularly useful,
>>> if you need to work around old applications such as dhcp clients,
>>> that do not work well with checksum offloads, but don't want to
>>> disable checksum offload in your device.
>>>
>>> The problem happens in the field with virtualized applications.
>>> For reference, see Red Hat bz 605555, as well as
>>> http://www.spinics.net/lists/kvm/msg37660.html
>>>
>>> Typical expected use (helps old dhclient binary running in a VM):
>>> iptables -A POSTROUTING -t mangle -p udp --dport 68 -j CHECKSUM
>>> --checksum-fill
>>
>> I'm not sure this is something we want to merge upstream and
>> support indefinitely. Dave suggested this as a temporary
>> out-of-tree workaround until the majority of guest dhcp clients
>> are fixed. Has anything changed that makes this course of
>> action impractical?
> 
> If I understand what Dave said correctly, it's up to you ...
> 
> The arguments for putting this upstream are:
> 
> Given the track record, I wouldn't hope for quick fix in the majority of
> guest dhcp clients, unfortunately :(.  We are talking years here.
> Even after that, one of the uses of virtualization is
> to keep old guests running. So yes, I think we'll
> keep using work-arounds for this for a very long time.
> 
> Further, since we have to add the module and we have to teach management
> to program it, it will be much less painful for everyone
> involved if we can put the code upstream, rather than forking
> management code.

Fair enough, its simple enough that I don't expect much maintenance
overhead.
