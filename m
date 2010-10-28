Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0J1Apx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:45:53 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4046 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab0J1Apv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:45:51 -0400
Message-ID: <4CC8C7BE.4010102@caviumnetworks.com>
Date: Wed, 27 Oct 2010 17:45:50 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Perf can't deal with many tracepoints
References: <E1PBFIJ-0004eC-Tj@tytso-glaptop> <4CC8C0D2.7060304@caviumnetworks.com> <20101028004047.GH3194@thunk.org>
In-Reply-To: <20101028004047.GH3194@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2010 00:46:19.0367 (UTC) FILETIME=[88FCBF70:01CB7639]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 05:40 PM, Ted Ts'o wrote:
> On Wed, Oct 27, 2010 at 05:16:18PM -0700, David Daney wrote:
>> Tracing is supposed to be low overhead.  Forcing people to decode
>> things like this at the trace point, may take more code and cause
>> the trace data to be larger, making it slower than necessary.
>>
>> If there isn't a good reason to keep perf stupid, then making it
>> smarter could be attractive.
>
> Agreed.  Although one argument against making perf smarter is that
> certain things such as the dev_t MAJOR/MINOR split is an internal
> abstraction that could potentially vary from kernel to kernel.
>
> And the question is whether perf really should be so different that if
> you boot a different kernel, you had better have the right perf
> installed.
>

It may be possible to encode the dev_t split in the trace meta-data. 
This is done for some other types.  Then perf could decode it based on 
the meta-data.

Another option is to have perf print the raw data and not crash.  Then 
someone looking at the output could, if they desired, decode the dev_t 
themselves.

David Daney
