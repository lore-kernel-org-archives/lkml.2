Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab1I3ClZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:41:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57216 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab1I3ClX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:41:23 -0400
Message-ID: <4E852C4D.4010307@gmail.com>
Date: Thu, 29 Sep 2011 20:41:17 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Jiri Olsa <jolsa@redhat.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
        Stephane Eranian <eranian@google.com>, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Exit recording if events have non matching
 sample type
References: <20110929230613.GA20083@ghostprotocols.net> <4E850056.1090101@gmail.com> <20110930004018.GA9369@ghostprotocols.net> <4E85142C.101@gmail.com> <20110930022134.GB9369@ghostprotocols.net>
In-Reply-To: <20110930022134.GB9369@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2011 08:21 PM, Arnaldo Carvalho de Melo wrote:
> Em Thu, Sep 29, 2011 at 06:58:20PM -0600, David Ahern escreveu:
>> On 09/29/2011 06:40 PM, Arnaldo Carvalho de Melo wrote:
>>> This comes from time to time:
>>>
>>> http://us.generation-nt.com/answer/bug-perf-event-sampling-buffer-format-cannot-handle-multi-event-sampling-help-202985832.html
>>>
>>> The whole point of sample_type is to ask for just what is needed for
>>> some specific event so that we reduce the per sample footprint.
>>>
>>> So we allow for multiple types of events to be on the same stream, but
>>> not for them to have just what each need, its a limitation, one that we
>>> can solve. I see no reason not to solve it :-)
>>>
>>> The evsel/evlist classes were designed to abstract away such details,
>>> i.e. perf_evlist__mmap should notice different sample_types and sort
>>> this out transparently.
>>>
>>> And then perf_evlist__mmap_read(evlist, idx), evlist->nr_mmaps should be
>>> enough to process the events :-)
>>>
>>> - Arnaldo
>>
>> An ABI change fixes the root cause of the current problem -- put an id
>> in perf_event_header. The id maps to the evsel which has the
>> sample_type. Right now you have to parse the sample to get the id to get
>> the evsel.
> 
> This id is not always needed, so it shouldn't go to perf_event_header.
> Peter, can you comment here? ;-)

I'm talking about a new 'id' that would always be needed *for samples*
-- it identifies the evsel it is associated with. The evsel has the
sample type. The sample_type is then used to parse it. Seems like a
simpler solution then having mmap's per sample type and then writing
separate files.

David
