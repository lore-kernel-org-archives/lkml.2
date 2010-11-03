Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0KCU3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:29:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14169 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0KCU3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gQI8W82D6E1fWARFatgK2YpcH/N0ovRdWovgtsqa5W08F3bTLUywe6X7WYHVpZ+WAH
         NCOyVN2eyoq6OFG4QPRw==
Message-ID: <4CD1C612.5080902@google.com>
Date: Wed, 03 Nov 2010 13:29:06 -0700
From: Mike Waychison <mikew@google.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Greg KH <greg@kroah.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, adurbin@google.com, akpm@linux-foundation.org,
        chavey@google.com, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH v1 00/12] netoops support
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>	<20101103023422.GB5782@kroah.com>	<AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>	<20101103181634.GF7441@kroah.com> <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft@mail.gmail.com>
In-Reply-To: <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Waychison wrote:
> FWIW, another semantic difference between netconsole and netoops (that
> I had missed in the last email) is filtering: we really do want to get
> the whole log when a crash happens, debug messages and all.
> Netconsole is subject to console filtering (which we _do_ want as
> debug messages going out the uart slows the whole world down).
> 
> netconsole and netoops _do_ have bits in common, for instance the
> handling of NETDEV events and source+target configuration.  I'd rather
> those bits become common between the two than figure out how to jam
> the semantics we need into netconsole.

Hi Matt,

I've been reading through the netconsole driver in response to Greg's 
comments on this thread, and it is definitely more robust in terms of 
configuration and handling of network device events than the netoops 
driver I proposed.

What are your thoughts on extending netconsole with the same sort of 
semantics that are in the netoops patchset?

I'd still like to have blit-dmesg-to-the-network-on-oops semantics, 
which seems doable by having a per-target flag for streaming of console 
messages (enabled by default) and a flag to emit a structured full dmesg 
dump (disabled by default).

I'd be happy to change this patchset to modify the netconsole driver if 
you agree.

Thanks,

Mike Waychison
