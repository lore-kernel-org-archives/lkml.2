Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab1EVLCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 07:02:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41124 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1EVLCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 07:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=IomctuRRBj0x90nsCcUi2+ZtcJ5jvW0pKlOOn4h8I6VS9h1ubyyDGoy+iBoqTAF/YE
         u7m3RPacINZ5xk8br2ySjIv0Xr2svF7i21QMEY2JGaU/TWJSH7lu6RjlcFVLZkEMeUAM
         EDqVUjmRgOMj1NB8/98TYL1j74xAAuy+sZHc4=
Message-ID: <4DD8ED2E.90508@gmail.com>
Date: Sun, 22 May 2011 15:02:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        heil@terminal-consulting.de, penberg@kernel.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        KVM devel mailing list <kvm@vger.kernel.org>
Subject: Re: [tip:tools/kvm] kvm tools: Add conditional compilation of symbol
 resolving
References: <tip-c474e3fec70bcacd5b24a24838c653e5a13e7b58@git.kernel.org> <20110522105816.GA13373@elte.hu> <20110522110035.GA14865@elte.hu>
In-Reply-To: <20110522110035.GA14865@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 03:00 PM, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>>
>> * tip-bot for Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>
>>> diff --git a/tools/perf/feature-tests.mak b/tools/kvm/config/feature-tests.mak
>>> similarity index 83%
>>> copy from tools/perf/feature-tests.mak
>>> copy to tools/kvm/config/feature-tests.mak
>>
>> Btw, now that we have feature-tests.mak it would be nice to populate the checks 
>> for the various assumptions.
>>
>> One i recently ran into on a new box where i tried to install tools/kvm was:
>>
>> In file included from /usr/include/features.h:387:0,
>>                  from /usr/include/unistd.h:26,
>>                  from include/kvm/util.h:12,
>>                  from bios/e820.c:5:
>> /usr/include/gnu/stubs.h:7:27: fatal error: gnu/stubs-32.h: No such file or directory
>> compilation terminated.
>> make: *** [bios/bios-rom.bin] Error 1
>>
>> that's a dependency on glibc-dev[el].
> 
> Another detail: on 64-bit hosts the dependency is on gibc-dev[el].i686, i.e. 
> the 32-bit package.
> 
> Would it be simple to remove this dependency? It's not typically installed by 
> default on distros and it would be nice to make most of the kvm code build by 
> default almost everywhere.
> 
> Thanks,
> 
> 	Ingo

  I'll take a look if we really need it (note we need to compile 16bit code for
bios blob so it might eventually be a problem ;)

-- 
    Cyrill
