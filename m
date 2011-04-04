Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1DDXLF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:11:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34439 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1DDXLB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:11:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZTBEnGZGVWJyGYWWAhM5bcsuIcWFnUegZ+/KpDRFT2bDxBu/VwKs4pY+wTGFAiH1jA
         Et0/L64C7b959HXyIuqA==
MIME-Version: 1.0
In-Reply-To: <4D9433DC.5020008@cn.fujitsu.com>
References: <20110323030326.789836913@google.com> <4D9433DC.5020008@cn.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 4 Apr 2011 16:10:11 -0700
Message-ID: <BANLkTim1rkrXcsFpGJ3oXjQhwgO9oZvs4A@mail.gmail.com>
Subject: Re: [patch 00/15] CFS Bandwidth Control V5
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 12:57 AM, Xiao Guangrong
<xiaoguangrong@cn.fujitsu.com> wrote:
> On 03/23/2011 11:03 AM, Paul Turner wrote:
>> Hi all,
>>
>> Please find attached the latest version of bandwidth control for the normal
>> scheduling class.  This revision has undergone fairly extensive changes since
>> the previous version based largely on the observation that many of the edge
>> conditions requiring special casing around update_curr() were a result of
>> introducing side-effects into that operation.  By introducing an interstitial
>> state, where we recognize that the runqueue is over bandwidth, but not marking
>> it throttled until we can actually remove it from the CPU we avoid the
>> previous possible interactions with throttled entities which eliminates some
>> head-scratching corner cases.
>>
>
> Hi Paul,
>
> I have wrote some codes to test this patchset. While run attached test case,
> the test program is blocked, it seams the children tasks can not be killed,
> after one or two hours, the watchdog is expired and triggers box crashed.
>

Sorry, I was out last week.

I'm taking a look at this now, I believe the interaction lies
somewhere within the quota return paths.

Thanks for taking the time to test!

- Paul
