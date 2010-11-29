Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0K2Eex (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 23:34:53 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43047 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0K2Eew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 23:34:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tL56YIWQNRdin4JUqYJViRizfKpeGz2Wss+CoZvvPqI/Dtg8DbajpMZSR7oDeA30Z2
         pvska6iA4o6m/cyiIEh74Zi46DbICxGHrygzFMvOXLQjXw+/pBWALz6phntSb8hI8qFi
         3nDP7WfFRbmoBk+tiEPPviizdRxpNddbcgBNs=
MIME-Version: 1.0
In-Reply-To: <AANLkTinkvA=cVb4+ctR6w6bTsevttwp3C016Z2XEMAOC@mail.gmail.com>
References: <1290598502-31727-1-git-send-email-tom.leiming@gmail.com>
	<20101124144540.GB15875@ghostprotocols.net>
	<AANLkTinkvA=cVb4+ctR6w6bTsevttwp3C016Z2XEMAOC@mail.gmail.com>
Date: Mon, 29 Nov 2010 12:34:49 +0800
Message-ID: <AANLkTi=U4echi4NzKan7uVgdCOEuhg5ZvBoWeqJH1sVT@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf:tools: avoid to create much more maps for kernel
 symbols on ARM
From: Ming Lei <tom.leiming@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/25 Ming Lei <tom.leiming@gmail.com>:
> 2010/11/24 Arnaldo Carvalho de Melo <acme@ghostprotocols.net>:
>> Em Wed, Nov 24, 2010 at 07:35:02PM +0800, tom.leiming@gmail.com escreveu:
>>> From: Ming Lei <tom.leiming@gmail.com>
>>
>>> On ARM, module addresss space is ahead of kernel space, so the module
>>> symbols are handled before kernel symbol in dso__split_kallsyms, then
>>> cause one map is created for each kernel symbol.
>>
>>> This patch fixes the issue by restoring to original kernel map in
>>> dso__split_kallsyms() to avoid create unnecessary maps for kernel
>>> symbols when starting to handle kenel symbol maps but after module
>>> symbol maps are handled over.
>>
>> Can you try with the following patch instead?
>
> Fine to me.
>
> Reported-and-tested-by: Ming Lei <tom.leiming@gmail.com>

Arnaldo, could you queue this one and the patch below

      http://marc.info/?l=linux-kernel&m=129068448714210&w=2

into your tree? Without the two, perf tool can't work well on ARM
if there are modules loaded.

thanks,
-- 
Lei Ming
