Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495Ab1EMPri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:47:38 -0400
Received: from mail-px0-f173.google.com ([209.85.212.173]:47958 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759466Ab1EMPrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:47:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=k8bIinC5kgGMeQr/njuL240XxHDdD5kmCeHGCNcUYyriPgjTb9HXmhsDzAIj7bHb9d
         aC7Fq0nABaTi8W1vMPIgwBBL9eN+g7KvmKNAaOJ9mRDXPuN9iEoCcRrxeSCHST6bt8h/
         LLaX4HktKiB+QuZv/7YZBnfXDSI8v1Gk5ZkOM=
Message-ID: <4DCD5112.3020307@gmail.com>
Date: Fri, 13 May 2011 09:41:06 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110421 Fedora/3.1.9-2.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Wim Heirman <wim@heirman.net>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: Re: perf-stat per thread results
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com> <20110513153028.GC3854@elte.hu>
In-Reply-To: <20110513153028.GC3854@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/11 09:30, Ingo Molnar wrote:

> Yes perf record --stat should work. 'perf report -T --stdio' is supposed to 
> print this, but it has regressed i think.

There is a known regression in 2.6.39; perf-record and perf-top cannot
profile all threads in a process. They fail with:

  Fatal: failed to mmap with 22 (Invalid argument)

Curiously, perf-stat does work - or at least does not fail with the mmap
error.

David


> 
> Arnaldo, any ideas?
> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
