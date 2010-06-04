Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab0FDMU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 08:20:57 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54997 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab0FDMU4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 08:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=w1r5cruhllUFAUNW/fqlD7Mk9QyCpZDh23rF5Jx/gSHKHStSzNFKGD5HkHCuC+V0KL
         CE7X1WJabe1FDDECNWAATM7wj4rrtQuh/Dj+ZjToBGSUssc4J4boK/rcluWWYe4tG88W
         NcCbCZgBKfgCkyBotHjh205+11hRITbrd3i5M=
MIME-Version: 1.0
In-Reply-To: <20100604075148.5bcd7c8d@corrin.poochiereds.net>
References: <AANLkTiliRFydAhxH2-Dp1RKuz6sq7vgWIcMvLMi68ftg@mail.gmail.com>
	<20100604075148.5bcd7c8d@corrin.poochiereds.net>
Date: Fri, 4 Jun 2010 07:13:00 -0500
Message-ID: <AANLkTimnSAvy4JmNiEyrgA_wXDNC9FphneDhNhe8FY5D@mail.gmail.com>
Subject: Re: wait_even_interruptible_timeout(), signal, spin_lock() = system 
	hang
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 6:51 AM, Jeff Layton <jlayton@redhat.com> wrote:
> On Fri, 28 May 2010 11:44:46 -0500
> Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:
>
>> After this sequence of calls, system hangs (smp, x86 box based with
>> .34 kernel), can ping only.
>> I have not been able to break in with Alt Sysrq t, working on that
>>
>>         rc = wait_event_interruptible_timeout(ses->server->response_q,
>>                         (midQ->midState != MID_REQUEST_SUBMITTED), timeout);
>>         if (rc < 0) {
>>                 cFYI(1, ("command 0x%x interrupted", midQ->command));
>>                 return -1;
>>         }
>>
>> and when function that invoking function after coming out with ERESTARTSYS
>> (I kill the command with Ctrl C) calls
>>  spin_lock(&GlobalMid_Lock);
>>
>> system hangs.  If I sleep before return -1 (e.g. msleep(1), no hang)
>>
>
> Sounds like a race of some sort, but could also be that msleep() is
> doing something (perhaps relating to the pending signal) that prevents
> the hang. Without some sort of clue as to what the box is hung on at
> the time there is no way to know.
>
>> I do not have to use wait_event_interruptible_timeout and no such problems with
>> wait_event_timeout, it is only when signal/interrupt is involved, I
>> run into this problem
>>
>> Any pointers/ideas what could be happening, would be really really appreciated.
>>
>
> No idea right offhand. I'd suggest getting a core or sysrq data and see
> what it's doing.
>
> --
> Jeff Layton <jlayton@redhat.com>
>

Jeff, Thanks.  The system hangs really hard. It does not respond to
Alt ScrLk  Ctrl ScrLk
key sequence at the text mode console i.e. nothing gets logged in
/var/log/messages.

Regards,

Shirish
