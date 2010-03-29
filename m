Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0C2Krd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:47:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37616 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab0C2Krc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:47:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BB0851B.3000908@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 19:46:51 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: mce: Xeon75xx specific interface to get corrected
 memory error information v2
References: <20100324054044.GA4307@basil.fritz.box> <87vdcf7ent.fsf@basil.nowhere.org> <4BB06500.5060105@jp.fujitsu.com> <20100329090156.GE20695@one.firstfloor.org>
In-Reply-To: <20100329090156.GE20695@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/03/29 18:01), Andi Kleen wrote:
>>>> Xeon 75xx doesn't log physical addresses on corrected machine check
>>>> events in the standard architectural MSRs. Instead the address has to
>>>> be retrieved in a model specific way. This makes it impossible
>>>> to do predictive failure analysis.
>>
>> Could you point proper specification or datasheet to know/check what
>> you are going to do here?
> 
> You mean how the model specific interface works?
> 
> There's currently no public specification for the interface,
> but it should be reasonably clear from reading the driver how
> it works.
> 
> -Andi

It looks like overengineered...

I have some questions: Is it impossible to get the address
after polling handler have processed?  e.g. Is it possible to
implement this module as mcelog's add-on that hooked & invoked
immediately after reading /dev/mcelog?  I guess there are
some limitation/restriction to call pfa_command().

Are there any alternative way to get the address?
Polling like edac_i7 doesn't help this?

You pointed "This makes it impossible to do predictive failure
analysis", but I guess we could do rough-but-enough analysis that
requires coarse resolution like sockets.  Or we should not expect
that one of DIMMs connected to the socket is broken if the socket
reports corrected memory errors many time?


Thanks,
H.Seto



