Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2BCOw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:52:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:26214 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034Ab2BCOw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:52:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="120328416"
Message-ID: <4F2BF4A7.2070603@linux.intel.com>
Date: Fri, 03 Feb 2012 06:52:23 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Chinmay V S <chinmay.v.s@pathpartnertech.com>
CC: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        linux-kernel@vger.kernel.org, cvs268@gmail.com, tglx@linutronix.de,
        jeff.chua.linux@gmail.com
Subject: Re: [RFC] [PATCH] [timer] Optimise apply_slack() for size and speed.
References: <1328002652-7700-1-git-send-email-chinmay.v.s@pathpartnertech.com> <20120202225917.GA1189@kibibi> <CAKZbaaTDcfEVPa2JRSnkv_YCiScoTTqpmzaGQGWT98QJpYzZ8A@mail.gmail.com>
In-Reply-To: <CAKZbaaTDcfEVPa2JRSnkv_YCiScoTTqpmzaGQGWT98QJpYzZ8A@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/2/2012 10:31 PM, Chinmay V S wrote:
> Here is the dis-assembly (build for x86) :
> 
> Original code snippet :
> mov    %eax,%ecx
> mov    $0x1,%edx
> shl    %cl,%edx
> sub    $0x1,%edx
> mov    %edx,-0x10(%ebp)
> not    %edx
> and    %esi,%edx
> mov    %edx,-0x14(%ebp)
> 
> Patched code snippet :
> mov    %eax,%ecx
> shrl   %cl,-0x14(%ebp)
> shll   %cl,-0x14(%ebp)
> 
> As is evident, we are able to reduce 5 instructions by using a bit-shift
> logic (compared to a masking logic).
> 

this code is so not performance critical to this level, that we should
optimize for readability, not for the output of a compiler.


