Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762297Ab2FVPSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:18:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36186 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421Ab2FVPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:18:38 -0400
Message-ID: <4FE48CCA.2050506@gmail.com>
Date: Fri, 22 Jun 2012 09:18:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RFC/PATCHSET 0/8] perf tools: Minimal build without libelf dependency
 (v2)
References: <1340343462-15556-1-git-send-email-namhyung@kernel.org>  <1340358478.18025.51.camel@twins> <1340377510.1478.10.camel@leonhard>
In-Reply-To: <1340377510.1478.10.camel@leonhard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/22/12 9:05 AM, Namhyung Kim wrote:
> Hi Peter,
>
> 2012-06-22 (금), 11:47 +0200, Peter Zijlstra:
>> On Fri, 2012-06-22 at 14:37 +0900, Namhyung Kim wrote:
>>> And then I realized that the perf record needs to know about the
>>> build-id's anyway. :( So I implemented a poor man's version of elf
>>> parser only for parsing the build-id info.
>>
>> Why? the very first versions didn't know about any of that nonsense :-)
>> It works just fine as long as you don't go change binaries around.
>>
>> That said, you did the work already, so no objection, just saying
>> builtids aren't that important.
>
> I'm not sure I understood you correctly. But 'perf record' needs to know
> about the build-id's to save them to perf.data for 'perf report' later.
> And 'perf archive' also needs to know about them to select necessary
> binaries for the session.
>

And build-id's are not required for report (-B option for record).

Also, the intent is for a small footprint binary for embedded systems. 
On such a system I would expect binaries and libraries to be stripped, 
so no point in running perf-archive.


David
