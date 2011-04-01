Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1DAUWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 16:22:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45936 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab1DAUW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 16:22:28 -0400
Message-ID: <4D9633E7.1010707@zytor.com>
Date: Fri, 01 Apr 2011 13:21:59 -0700
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
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop> <4D95F80D.7070201@kernel.org> <4D95FBDD.9050901@zytor.com> <alpine.DEB.2.00.1104011729000.16492@kaball-desktop> <4D961FBC.2030105@zytor.com> <4D962837.2070300@kernel.org> <4D96294B.5050909@zytor.com> <4D962D72.2010501@kernel.org>
In-Reply-To: <4D962D72.2010501@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 12:54 PM, Yinghai Lu wrote:
> 
> ok, please check if you are happy with this one.
> 

The best would simply be:

	mmu_cr4_features = read_cr4_safe();

If this has to run before we can handle exceptions, one can verify the
existence by testing for the CPUID instruction (a CPU has CR4 if and
only if it has CPUID):

	if (boot_cpu_data.cpuid_level >= 0)
		mmu_cr4_features = read_cr4_safe();

... since we set cpuid_level to -1 if there is no CPUID instruction.

	-hpa
