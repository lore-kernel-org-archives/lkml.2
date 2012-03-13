Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab2CMBIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:08:21 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55802 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab2CMBIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 21:08:16 -0400
X-AuditID: 9c930179-b7b92ae000005ed3-a2-4f5e9dfd688e
Message-ID: <4F5E9DFB.40203@lge.com>
Date: Tue, 13 Mar 2012 10:08:11 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf: Integrate logging facilities
References: <4F5DC8D9.9030608@lge.com> <4F5E1BA4.2000209@gmail.com>
In-Reply-To: <4F5E1BA4.2000209@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-13 12:52 AM, David Ahern wrote:
> On 3/12/12 3:58 AM, Namhyung Kim wrote:
>> This is a rough idea and there can be things I am missing. So I need to
>> listen to your advices.
>
> What Arnaldo proposed was having core, library code return error codes and not
> print anything to the user. Higher layers (commands only?) can take the return
> error code and pass it to perf_<subsystem>_strerror() to dump a user friendly
> string for the error. See
>
> http://lkml.org/lkml/2012/2/13/302
>

It will work well for error cases, but how about warnings? I mean the case of 
something like handling new features on old kernels. I want give a (warning) 
message to user but let the code keep going instead of returning to the user. 
It seems not possible on above scenario, so should it be handled at all in 
higher layers? Couldn't the core code have that kind of flexiblity?

And current library code has lots of calls to pr_debug*, dump_printf as well 
as (something-or-)die. How can we handle this? For debugging functions, it 
cannot be moved out of the library for obvious reasons. For die, it can be 
converted to return a error code, but it might require adding non-trivial 
error handling path especially for deeply nested code IMHO.

Also, I think my proposal can still be applied for higher layer codes. It'd be 
better to standardize logging facilities at least for high level in order to 
be flexible for future changes.

Thanks,
Namhyung
