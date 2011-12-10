Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab1LJO1P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 09:27:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab1LJO1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 09:27:12 -0500
Message-ID: <4EE36C43.2040508@suse.cz>
Date: Sat, 10 Dec 2011 15:27:15 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Rewriting kernel config after generation
References: <20111202053342.GA13877@p183.telecom.by> <CACVxJT94xTVO3i7tzLwrjTkFdr3+ve2e1VBg6UjzVfvthtgDfw@mail.gmail.com>
In-Reply-To: <CACVxJT94xTVO3i7tzLwrjTkFdr3+ve2e1VBg6UjzVfvthtgDfw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.12.2011 12:45, Alexey Dobriyan wrote:
> On Fri, Dec 2, 2011 at 7:33 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
>> I'm trying to add compiling with -march=native to the kernel.
>> The problem is that then some config options become discoverable at
>> the beginning of the compilation. For example,
>> CONFIG_X86_L1_CACHE_SHIFT=6 can be derived from "--param l1-cache-line-size=64".
>> I suspect this is no-go, because all the dependency logic must be
>> duplicated somewhere else (in the march=native script) for the above
>> to work.
>>
>> Is there any cleaner way I'm missing?
>>
>> In theory, such script could even turn off CONFIG_CPU_SUP_AMD
>> if it detects Intel CPU.
> 
> Hrph, this is harder than it looks because "silentoldconfig" is done at
> the beginning rewriting whatever changes done to .config by hand. :-(

X86_L1_CACHE_SHIFT has no prompt, so it cannot be modified by the user.
You would need to add a prompt if you want to modify it, e.g.

config X86_L1_CACHE_SHIFT
        int
	prompt "..." if X86_MARCH_NATIVE

But I wonder why is this needed. To build for the native cpu, you only
need to detect what cpu you are running and select the matching
processor family. The x86 Kconfig/Makefile will then take care of
setting the right kconfig options and the right -march= parameter for gcc.

Michal
