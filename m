Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab1BITiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 14:38:01 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49467 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab1BITiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 14:38:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=iAHXbQojEufNsIwdU9nB8on5rZ/8RP4L5SGumzJ3WiGm0Y/RxUhWVxSJg1OKd89gx5
         37zYQU5sdalV4p2uRL1vXWXyr/TOoBBnbzuSBrl3f7sWsPJioUMNiSad7BXTuVdcqKvH
         pXdkYT13CXRlkd89t0yf3JxwJBdKGBBG2N1o0=
MIME-Version: 1.0
In-Reply-To: <20110209145304.GB16737@elte.hu>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
 <20110128165455.GA18194@elte.hu> <20110128175532.GA26727@redhat.com>
 <20110128182947.GB20056@elte.hu> <20110205203422.GA12443@redhat.com>
 <20110207130841.GA16054@redhat.com> <AANLkTimS7vi_BLV_KUw_AKm4DzhV=43Bm3y_epm0rzj9@mail.gmail.com>
 <20110209145304.GB16737@elte.hu>
From: Michael Witten <mfwitten@gmail.com>
Date: Wed, 9 Feb 2011 13:37:28 -0600
Message-ID: <AANLkTi=HxRZjXKPTg1d3A+Z21PoDFWx7VYwGZDizUf6b@mail.gmail.com>
Subject: Re: Bash not reacting to Ctrl-C
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        bug-bash@gnu.org, Chet Ramey <chet.ramey@case.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 08:53, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Michael Witten <mfwitten@gmail.com> wrote:
>
>> On Mon, Feb 7, 2011 at 07:08, Oleg Nesterov <oleg@redhat.com> wrote:
>> > Now that it is clear what happens, the test-case becomes even more
>> > trivial:
>> >
>> >        bash-4.1$ ./bash -c 'while true; do /bin/true; done'
>> >        ^C^C
>> >
>> > needs 4-5 attempts on my machine.
>>
>> I feel like the odd penguin out.
>>
>> I can't reproduce the behavior in question when using that example (I
>> haven't tried the other).
>>
>> I'm running:
>>
>>     * bash version 4.1.9(2)-release (i686-pc-linux-gnu)
>>
>>     * linux 2.6.38-rc4 (100b33c8bd8a3235fd0b7948338d6cbb3db3c63d)
>
> Oleg provided another testcase, can you reproduce the Ctrl-C problem with this
> it?
>
> #!/bin/bash
>
> perl -we '$SIG{INT} = sub {exit}; sleep'
>
> echo "Hehe, I am going to sleep after ^C"
> sleep 100
>
>
> Thanks,
>
>        Ingo
>

Yes, that requires me to press Ctrl-C twice in order to escape the
entire script. However, what do you expect the following to do:

#!/bin/bash

perl -we '$SIG{INT} = "IGNORE"; sleep 10'

echo "Hehe, I am going to sleep after ^C"
sleep 100
