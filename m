Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab1BCRC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:02:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35996 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518Ab1BCRC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:02:56 -0500
Message-ID: <4D4ADFAD.7060507@zytor.com>
Date: Thu, 03 Feb 2011 09:02:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when destroying
 mappings
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com> <alpine.DEB.2.00.1102031114030.7277@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1102031114030.7277@kaball-desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2011 03:25 AM, Stefano Stabellini wrote:
>>
>> How on Earth would you end up with a reserved region *inside the BRK*?
> 
> I think in practice you cannot, but you can have reserved regions at
> _end, that is the main problem I am trying to solve.
> If we have a reserved region at _end and _end is not PMD aligned, then
> we have a problem.
> 
> I thought that checking for reserved regions before destroying the
> mapping would be a decent solution (because it wouldn't affect the
> normal case); so I ended up checking between _brk_end and _end too.
> 
> Other alternative solutions I thought about but that I discarded because
> they also affect the normal case are:
> 
> - never destroy mappings that could go over _end;
> - always PMD align _end.
> 
> If none of the above are acceptable, I welcome other suggestions :-)
> 

Sounds like the code does the right thing, but the description needs to
be improved.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

