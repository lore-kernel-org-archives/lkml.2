Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690Ab1DAXNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:13:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33280 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab1DAXNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:13:16 -0400
Message-ID: <4D965BED.5000309@zytor.com>
Date: Fri, 01 Apr 2011 16:12:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
References: <20110330203215.0a1a41a7@xenia.leun.net>	<20110331090524.07ad0069@xenia.leun.net>	<alpine.DEB.2.00.1103311546480.16492@kaball-desktop>	<201103312348.53678.rjw@sisk.pl>	<4D94FE37.8070109@kernel.org>	<alpine.DEB.2.00.1104011230550.16492@kaball-desktop>	<4D95F80D.7070201@kernel.org>	<4D95FBDD.9050901@zytor.com>	<alpine.DEB.2.00.1104011729000.16492@kaball-desktop>	<4D961FBC.2030105@zytor.com>	<4D962837.2070300@kernel.org>	<4D96294B.5050909@zytor.com>	<4D962D72.2010501@kernel.org>	<4D9633E7.1010707@zytor.com>	<AANLkTi=VzMh84szSBNujVU8oLZfzQd_z2bg+O3K_8GMd@mail.gmail.com>	<4D9643F1.1090807@zytor.com> <AANLkTimd22epcYvZRrvP5p3CzArpnR3To_mKCjdKKuf8@mail.gmail.com> <4D9646C6.7060301@zytor.com> <4D965A08.2080203@kernel.org>
In-Reply-To: <4D965A08.2080203@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 04:04 PM, Yinghai Lu wrote:
> On 04/01/2011 02:42 PM, H. Peter Anvin wrote:
>>
>> And why on Earth is it worth saving a couple of instructions (and
>> introducing code ugliness and a more complex testing matrix) in the case
>> when it is not?
> 
> Please check this one, it moves storing mmu_cr4 to arch_prepare_suspend.
> 

You keep moving things around instead of answering the question.  It
might be the right thing to do, but I would like an answer why, in your
opinion, the easy way isn't feasible.

For suspend/resume, the right thing really is just to save CR4 like any
other processor register.

	-hpa
