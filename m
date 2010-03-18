Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab0CRKMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 06:12:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182Ab0CRKMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 06:12:23 -0400
Message-ID: <4BA1FC86.6020504@suse.cz>
Date: Thu, 18 Mar 2010 11:12:22 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kconfig: report select on a depending option
References: <alpine.LSU.2.01.1003181015060.9334@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1003181015060.9334@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.3.2010 10:21, Jan Engelhardt wrote:
> Hi,
> 
> 
> With the following combination of Kconfig config options, I can select 
> TEST_Z, which will select TEST_X, even if TEST_Y=n. It also allows for 
> awkward situations like TEST_Y=M, TEST_X=y, TEST_Z=y, which would yield 
> a link time error when X uses Y's symbols.

That's a known bug unfortunatelly
(Documentation/kbuild/kconfig-language.txt):
  Note:
        select should be used with care. select will force
        a symbol to a value without visiting the dependencies.
        By abusing select you are able to select a symbol FOO even
        if FOO depends on BAR that is not set.
        In general use select only for non-visible symbols
        (no prompts anywhere) and for symbols with no dependencies.
        That will limit the usefulness but on the other hand avoid
        the illegal configurations all over.
        kconfig should one day warn about such things.



> Is there a way to have such potential errors reported with kconfig?

No there isn't. There is a guy who wants to work on improving/rewriting
the kconfig depsolver during GSoC, let's see :). But a warning should be
easy to add now, I think.

Michal
