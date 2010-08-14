Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab0HNIwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 04:52:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54322 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985Ab0HNIwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 04:52:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:organization:message-id:references
         :in-reply-to:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=f1SeAli6BHWgqupCSWTxnociRouLtfhNr9daycYPzMy8pmM0rEo2Z5iwyv9ENjyRz2
         pGiWfNWnbLlKKKWObmdxQHVVe9s12rbsai34piA+8yZsrIVq/Pfj/TykAOJkibkgGvm/
         k7mYRvXAXdpuOjucBVWkJjjoVMgiqm7tgCCaE=
From: Grant Coady <gcoady.lk@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [0/3] 2.6.27.52 stable review
Date: Sat, 14 Aug 2010 18:52:01 +1000
Organization: scattered
Message-ID: <88mc66l6fnh1i5mhqo3gqmdlti2vajesar@4ax.com>
References: <20100813214704.GA18960@kroah.com> <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com> <20100813230712.GA1703@suse.de> <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com> <AANLkTimruyaAB-raY2ywqPQSR-h+yp7tME=eTKngcMQm@mail.gmail.com> <20100814004729.GA3695@suse.de> <h6hc66dkok3im9jpph1oj2m40ijju6c9la@4ax.com> <20100814074333.GF21003@1wt.eu>
In-Reply-To: <20100814074333.GF21003@1wt.eu>
X-Mailer: Forte Agent 6.00/32.1186
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010 09:43:33 +0200, you wrote:

>On Sat, Aug 14, 2010 at 05:34:55PM +1000, Grant Coady wrote:
>> On Fri, 13 Aug 2010 17:47:29 -0700, you wrote:
>> 
>> >On Fri, Aug 13, 2010 at 05:12:57PM -0700, Linus Torvalds wrote:
>> >> On Fri, Aug 13, 2010 at 4:47 PM, Grant Coady <gcoady.lk@gmail.com> wrote:
>> >> >
>> >> > Machine is running, but there's a lot of these in the dmesg:
>> >> >
>> >> > WARNING: at include/linux/security.h:1826 acct_stack_growth+0xe7/0xf0()
>> >> 
>> >> That would seem to be because of the lack of commit 05fa199d45c in
>> >> 2.6.27. It got marked for stable, but probably never went so far back
>> >> as 2.6.27.
>> >
>> >Yup, I didn't include it there.  Grant, if you add that, does the
>> >warning go away?
>> 
>> I'm sorry, no idea at all how to cherry pick that, I don't know git :( 
>> 
>> Google brings up this thread but not that commit, point me at it and 
>> I'll try it.  
>
>Simply apply this patch (even by hand) :
>
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=05fa199d45c
>
>It solved the warnings for me.

Thanks Willy, got:

grant@deltree:~/linux/linux-2.6.27.52-rc1b$ patch -p1 < ../patch-05fa199d45c
patching file mm/mmap.c
Hunk #1 succeeded at 1573 (offset -2 lines).

Compiling. . . 

Yup, works for me :)

  http://bugsplatter.id.au/kernel/boxen/deltree/dmesg-2.6.27.52-rc1b.gz

Cheers,
Grant.
