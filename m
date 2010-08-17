Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100Ab0HQHIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:08:41 -0400
Received: from edu-smtp-02.edutel.nl ([88.159.1.176]:52095 "EHLO
	edu-smtp-02.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab0HQHIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:08:39 -0400
Message-ID: <4C6A3573.3070403@neli.hopto.org>
Date: Tue, 17 Aug 2010 09:08:35 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 4/9] RapidIO: Add relation links between RIO device structures
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-5-git-send-email-alexandre.bounine@idt.com> <4C692C9D.6040100@neli.hopto.org> <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F1F@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E552011D5F1F@CORPEXCH1.na.ads.idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bounine, Alexandre wrote:
>> As RapidIO is a switched network, the concept of 'previous' and 'next'
>> devices is invalid. Perhaps it's just the way they were
>> discovered/enumerated, but that does not matter any more at runtime.
>> Or at least, should not matter.
>>
> 
> Yes, the "previous" and "next" have to be considered in context of
> enumeration/discovery.
> At runtime, it does not matter for data traffic, but is valuable
> information for error recovery

I agree it's desirable to have this information. Notes:
1) is rio_dev->prev used anywhere? (maybe I missed it)
2) is the nextdev[port] list complete? I mean are all connected switches 
in the list? My guess is that multiply connected switches are enumerated 
only once therefore only appear in the nextdev if only one switch, 
instead of all
3) it would be nice to have all switch connections information.

In case ever the network is rerouted, this information will become 
useful; instead of having a tree representation of the network only.

Micha
