Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1DNUS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 16:18:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61779 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1DNUS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 16:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LwLV7gZR3L+lzFnZVKaB53e2md8aDOYcuUhGzXpRHxODWBoSLN+G/LJlf6P/uJEKXa
         Sc37sA7ItbmS1rUikCOlgbvLUrO/xDGHJc67paJSyxYtUzGe9ih56QU92GpMoi1Lb+rL
         gwT/6P43L5ywlgwaMSFopqDwLNNBBWO2udYaE=
Message-ID: <4DA756AC.6030201@gmail.com>
Date: Fri, 15 Apr 2011 00:18:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu> <20110414183231.GN16939@redhat.com> <20110414184606.GD16064@elte.hu> <4DA74E5D.4060002@openvz.org> <20110414195748.GO16939@redhat.com> <4DA75373.9040705@openvz.org>
In-Reply-To: <4DA75373.9040705@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2011 12:05 AM, Cyrill Gorcunov wrote:
...
>>
>> I don't think this patch will work.  It would make sense if the unmasking
>> happened _after_ the "if (!handled)" path, but that is not the path Ingo
>> wanted for v1.
> 
> This thing happened if inflight nmi reaches the system and note that inflight
> NMI comes from perf and masks lvt entry, it has nothing to do with "handled" but
> rather the _fact_ that NMI reached apic via LVTPC and as result -- masked it.
> Don, I might be missin something, brain is slowly going to sleep :)
> 

Seems I'm wrong in this assumption, otherwise when this mechanism was
introduced for first time every in-flight nmi catched would block further
perf activity.

>>
>> Cheers,
>> Don
>>

-- 
    Cyrill
