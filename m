Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1EaNHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:07:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42307 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1EaNHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=GLLaXjZJSz7hnlW1xixq8g+zcOVghWVzC+gLVmv0j/QbgffIBtcxz6VUGnVXtJnLLj
         Qz0lL8yCphHfXgU1S6ZNCZvCFwVwaSIAjkCeznHr+jCp5n9WFjOipxHEMJ02+trtTuHZ
         aOiE5JzW8l/vMt60u722YR19EbHg+4BPXxEg8=
MIME-Version: 1.0
In-Reply-To: <20110531125415.GD10249@elte.hu>
References: <cover.1306517576.git.luto@mit.edu> <20110529191924.GD9835@elte.hu>
 <BANLkTin9xfS_X9Bscf1qnNZMK=JBgpzV8Q@mail.gmail.com> <20110531080758.GA24172@elte.hu>
 <BANLkTi=Gi_0Uyj+dA6GjriRU9fCzKuLU=g@mail.gmail.com> <20110531125415.GD10249@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 09:06:45 -0400
X-Google-Sender-Auth: 6gqR4BRuYzEYj0alSBiVoSSDRgU
Message-ID: <BANLkTinqGUoFTp3YcuUTAPUOUwBCQaw07g@mail.gmail.com>
Subject: Re: [PATCH 0/5] x86-64: Remove syscall instructions at fixed addresses
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 8:54 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> [...] More importantly, vread_tsc contains an alternative and the
>> vDSO can't currently contain alternative instructions.  That can
>> probably be fixed, but it'll take a bit of work.
>
> You could start with picking the more compatible alternative
> instruction initially. I don't at all mind losing half a cycle of
> performance in that case ... this code should be secure first.

The more compatible one is mfence, which in some cases could (I think)
be a lot more than half a cycle.

A better option might be rdtscp, which is actually documented to work,
but I'm not sure it's available on all supported CPUs.

I'm content to wait a bit on this one.  I say let's get the rest done
first and tackle the last little hard part at the end.

--Andy

>
> Thanks,
>
>        Ingo
>
