Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1EKPmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:42:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41802 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1EKPmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:42:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=G4Hn60JBj1ytDJo5CBNzbVz4IbA6l8IJ8ZAJ4uN1uTfVh3qHd7sk1hBHO+c0FOaWl7
         RkQ9G4LfHRN62WITgi9wLtCIZNIAFwT12T5PZQpLZdcv4p8jpN43WBzTPC//dsB23+XR
         Mk8+/TfH1ZrthOUXNh91pRA8QbXSf7r/Hs8fw=
MIME-Version: 1.0
In-Reply-To: <1305126680.2914.238.camel@laptop>
References: <tip-99ee5315dac6211e972fa3f23bcc9a0343ff58c4@git.kernel.org>
 <1305109433.2914.208.camel@laptop> <BANLkTi=j6eSyyEdGgUeZhQLJVa+meK_W6A@mail.gmail.com>
 <1305121541.2914.213.camel@laptop> <BANLkTik5szBkinZEWySVjBKA5GF+6dn8Yg@mail.gmail.com>
 <1305122518.2914.224.camel@laptop> <BANLkTim5WzcrzSiqhwXrhDDwcxF=JTpZew@mail.gmail.com>
 <1305124250.2914.225.camel@laptop> <BANLkTimvqAY9hwHujUVoQhN2eZQz-MVhgg@mail.gmail.com>
 <1305125333.2914.229.camel@laptop> <BANLkTi=aOsRs4iS_j41=NNESC2rgmwtpbg@mail.gmail.com>
 <1305126680.2914.238.camel@laptop>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 11 May 2011 17:17:02 +0200
Message-ID: <BANLkTinFwmd-gEmSFpTuBg_dueXWGg5mxQ@mail.gmail.com>
Subject: Re: [tip:timers/core] timerfd: Allow timers to be cancelled when
 clock was set
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        johnstul@us.ibm.com, davidel@xmailserver.org, virtuoso@slind.org,
        tglx@linutronix.de, chris.friesen@genband.com, kirill@shutemov.name,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 17:11, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-05-11 at 16:53 +0200, Kay Sievers wrote:
>>
>> > Dunno, an eventfd that triggers every time someone calls adjtime() and
>> > related?
>>
>> I think, we are exactly not interested in adjtime() calls, but only in
>> jumps in wall clock time.
>
> adjtime(), adjtimex() and settimeofday() are afaik the only ways to make
> walltime jump. Anyway what are you arguing about, don't you want the
> notification or do you insist on making the kernel slower for the 3
> people who care about this daftness?

I want a sane interface to get notified about changes to the time
which I asked the kernel to manage for me while I'm sleeping. The
interface in this patch does exactly that, in a very nice way.

If you think that needs to change, please discuss/provide
alternatives, which we can check if they sufficiently work for us,
like we did with this patch.

But please stop rhetorically asking me if I want a slower kernel, and
chance your tone. That will get us nowhere.

Kay
