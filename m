Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2GJXip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:38:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38581 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab2GJXin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:38:43 -0400
Message-ID: <4FFCBD00.1030109@gmail.com>
Date: Tue, 10 Jul 2012 17:38:40 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf with precise attribute kills all KVM based VMs
References: <4FFAE6D8.5050609@gmail.com> <20120709141904.GC7298@redhat.com>   <1341843844.3462.75.camel@twins> <4FFAED16.7050204@redhat.com>   <4FFAEF13.7010108@gmail.com> <1341845396.3462.81.camel@twins>  <4FFAEFF1.9000706@redhat.com> <1341845999.3462.86.camel@twins>
In-Reply-To: <1341845999.3462.86.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/12 8:59 AM, Peter Zijlstra wrote:
> On Mon, 2012-07-09 at 17:51 +0300, Avi Kivity wrote:
>> On 07/09/2012 05:49 PM, Peter Zijlstra wrote:
>>> On Mon, 2012-07-09 at 08:47 -0600, David Ahern wrote:
>>>>
>>>> I found this testing changes to perf-kvm, but found the problem extends
>>>> to just perf-record. With perf-record exclude_guest defaults to 1. See
>>>> tools/perf/util/util.c, event_attr_init().
>>>
>>> You lost me there.. so perf-record defaults to exclude_guest=1 (which
>>> would make the proposed patch I just send actually possible), but its
>>> still going *bang* ?
>>
>> It's possible that the DS writes overshoot the MSR... or that there's a
>> bug somewhere.
>
> OK, so the first thing to stare at is in what order the MSRs are
> touched, I think you first need to stop the counter, then clear the PEBS
> bits, then clear the DS_AREA one.
>

Any updates on the options for this or is there still squinting going on 
with MSR orders?

I guess it's a good thing Ingo's request for :pp to be the default was 
not implemented:
   https://lkml.org/lkml/2012/5/14/26

David
