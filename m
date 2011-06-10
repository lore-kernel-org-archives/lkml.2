Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab1FJAv4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 20:51:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57753 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab1FJAvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 20:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sz28AgjVCllJ4IpIDWYVhHUOZDpsUsSzGxGODFKH7CpzIh59CEcsVGjWyJQxSl6Gk9
         m13DnGbZ+XVGv8QZNFiMVt9eCIt+Qv5N3vxADJMe+MuahNSpoZ3DaG4tiTCwHmT1sTpZ
         PjvIKVSJecDyX6ezGsFstn1i6e709gI5tE6Y8=
MIME-Version: 1.0
In-Reply-To: <20110609185259.GA29287@linux.vnet.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
	<20110528005640.9076c0b1.akpm@linux-foundation.org>
	<20110609185259.GA29287@linux.vnet.ibm.com>
Date: Fri, 10 Jun 2011 09:51:53 +0900
X-Google-Sender-Auth: ZDlmkDBQ4ym7w2-Hj67gA-TrkCg
Message-ID: <BANLkTinxeeSby_+tta8EhzCg3VbD6+=g+g@mail.gmail.com>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory Power Management
From: Kyungmin Park <kmpark@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ankita Garg <ankita@in.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 3:52 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sat, May 28, 2011 at 12:56:40AM -0700, Andrew Morton wrote:
>> On Fri, 27 May 2011 18:01:28 +0530 Ankita Garg <ankita@in.ibm.com> wrote:
>>
>> > This patchset proposes a generic memory regions infrastructure that can be
>> > used to tag boundaries of memory blocks which belongs to a specific memory
>> > power management domain and further enable exploitation of platform memory
>> > power management capabilities.
>>
>> A couple of quick thoughts...
>>
>> I'm seeing no estimate of how much energy we might save when this work
>> is completed.  But saving energy is the entire point of the entire
>> patchset!  So please spend some time thinking about that and update and
>> maintain the [patch 0/n] description so others can get some idea of the
>> benefit we might get from all of this.  That estimate should include an
>> estimate of what proportion of machines are likely to have hardware
>> which can use this feature and in what timeframe.
>>
>> IOW, if it saves one microwatt on 0.001% of machines, not interested ;)
>
> FWIW, I have seen estimates on the order of a 5% reduction in power
> consumption for some common types of embedded devices.

Wow interesting. I can't expect it can reduce 5% power reduction.
If it uses the 1GiBytes LPDDR2 memory. each memory port has 4Gib,
another has 4Gib. so one bank size is 64MiB (512MiB / 8).
So I don't expect it's difficult to contain the free or inactive
memory more than 64MiB during runtime.

Anyway can you describe the exact test environment? esp., memory type?
As you know there are too much embedded devices which use the various
environment.

Thank you,
Kyungmin Park
>
>                                                        Thanx, Paul
>
>> Also, all this code appears to be enabled on all machines?  So machines
>> which don't have the requisite hardware still carry any additional
>> overhead which is added here.  I can see that ifdeffing a feature like
>> this would be ghastly but please also have a think about the
>> implications of this and add that discussion also.
>>
>> If possible, it would be good to think up some microbenchmarks which
>> probe the worst-case performance impact and describe those and present
>> the results.  So others can gain an understanding of the runtime costs.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
