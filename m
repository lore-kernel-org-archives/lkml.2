Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab1DGOnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 10:43:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59961 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab1DGOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 10:43:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=v4Acj6rmEY6jgISBne4MFVzfe5F8W87joXdRvJJC0Yxz+f1cdNmxiWLbKCSauZgE7+
         wqZ+VR937Au8RGpkBUAFyz4zibOFsSe62eJdi/TaQfOzwU3fS08Iuk7P2d9mTX5BDYg/
         e98BgbT3HTHQNeoRNReLSnjLbs+FpB2lILk5U=
Message-ID: <4D9DCD75.8060504@openvz.org>
Date: Thu, 07 Apr 2011 18:43:01 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Shaun Ruffell <sruffell@digium.com>
CC: Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [regression 2.6.39-rc2][bisected] "perf, x86: P4 PMU - Read proper
 MSR register to catch" and NMIs
References: <20110406223036.GA15721@digium.com> <20110407001658.GW12642@redhat.com> <BANLkTi=W45VbeBNThBqKv2Wbo+8sWxXjuA@mail.gmail.com> <20110407143858.GA18616@digium.com>
In-Reply-To: <20110407143858.GA18616@digium.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 06:38 PM, Shaun Ruffell wrote:
> On Thu, Apr 07, 2011 at 07:18:50AM +0400, Cyrill Gorcunov wrote:
>> On Thursday, April 7, 2011, Don Zickus <dzickus@redhat.com> wrote:
>>> On Wed, Apr 06, 2011 at 05:30:36PM -0500, Shaun Ruffell wrote:
>>>>
>>>> I was able to bisect it down to commit 242214f9c1eeaae40, but I'm not
>>>> certain where to go from here.  Is this something that is already known
>>>> or is there more information I should try to collect?
>>>
>>> Nope, this is an ongoing issue.  What happened was the perf P4 nmi handler
>>> was swallowing all the NMIs.  My patch fixed that and exposed a double NMI
>>> problem.  We have been chasing it for a couple of months.  I think Cyril
>>> was finally able to duplicate it (as he wrote the P4 code).  I have
>>> confidence that he will find a fix for it soon. :-)
>>>
>>> Thanks for the report though!
>>
>> Hi, yeah, i got it too and i hope to fix this issue soon. Will ping as
>> only get working fix.
> 
> Don, Cyrill,
> 
> Thanks for the explanation and my apologies for not relating the
> previous discussions about this to what I was seeing. This issue would
> be a blocker for any 2.6.39 final right?

Well, could be, I didn't find the real reason for doubled nmi.
Still investigating. As a workaround you could simply disable
nmi-watchdog for a while in command line if it bothers you.

> 
> Cyrill, I would be more than happy to test any patches. It's relatively
> quick for me to reproduce.

OK, I'll prepare some patches for you to test. Still think on where it
could fails :( Stay tuned.

> 
> Thanks,
> Shaun

-- 
    Cyrill
