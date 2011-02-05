Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1BEOjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:39:53 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:65068 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab1BEOjw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:39:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FO/JEabnPNX1w3+hSSgPdGy7OezsnGEx1e69dOpBDM8tuxHpJ0+OQbBZDu8jMM4nEX
         b5U7LwbvPudvCDuVdUHHhgFB5X1a4Sw5gTmiXkRAS+ibTvMJryI98XOytiQkS15ENh/X
         RYD45nyp9lO6qdLlN1vR6MMxNNh8pB1UDj914=
MIME-Version: 1.0
In-Reply-To: <AANLkTim7A4q1dF9QAPux-RpatAfOVL3n6ag0MRi-vTGs@mail.gmail.com>
References: <AANLkTim7A4q1dF9QAPux-RpatAfOVL3n6ag0MRi-vTGs@mail.gmail.com>
Date: Sat, 5 Feb 2011 15:39:51 +0100
Message-ID: <AANLkTikojfefJUxZ2vRfL2S4h5d+5Do0b1mPh4DPi9Ax@mail.gmail.com>
Subject: Re: Regarding SIGSEGV
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 8:08 AM, Sri Ram Vemulpali
<sri.ram.gmu06@gmail.com> wrote:
> Hi all,
>
>       I know that when a thread in an application do invalid memory
> reference, OS generates SIGSEGV(segmentation fault) signal and
> terminates application. What if we handle this signal by defining a
> signal handler to perform to terminate only the thread did invalid
> memory reference.
The thread that performed an invalid memory reference might already
have corrupted vital data structures, so the application may not work
and/or produce incorrect results. In such cases is always better to
stop the whole process, to limit damage.
> So, that the application will not be terminated.
> Also, is there any way, we can find when SIGSEGV is generated to get
> the invalid memory reference and thread id, who caused this fault.
man sigaction.
If you use the
 void     (*sa_sigaction)(int, siginfo_t *, void *);
version of handler interceptor, you will get the siginfo_t with all
known information about who generated the signal.

Corrado

> I know debuggers are written in such fashion. Can anyone point me to
> right direction. Thanks in advance.
>
> --
> Regards,
> Sri.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
