Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab1CBLw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 06:52:58 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42221 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab1CBLw5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 06:52:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qADAJ6gWNTyrkndZO432aaQfX7Wtop30HDMwHBTiQXIC9OxOsHuPnMXLrQtB0B3pgj
         JTl6EFCp4NenwaJ7MeQ8EDq0zFenpHicY5djLBCsanpx2idN8tzqeLtxjtgBaglBJebE
         KZeqZgyoopHPaMxFAoWlRW3JHv1vGWkUGNrDk=
MIME-Version: 1.0
In-Reply-To: <6b211a19ed02fa7f001343fbd8e3d5a9.squirrel@webmail.greenhost.nl>
References: <20110301152457.GE26074@htj.dyndns.org> <201103011757.48593.vda.linux@googlemail.com>
 <20110301170953.GB17933@htj.dyndns.org> <AANLkTi=8=Tw2aYzvwM_s8dsMmw3W_tYjsYkqTHS9moUW@mail.gmail.com>
 <20110301183454.GC23527@mtj.dyndns.org> <830cc1666bd4a610d5e870218f06bd2d.squirrel@webmail.greenhost.nl>
 <20110302074447.GE19669@htj.dyndns.org> <6b211a19ed02fa7f001343fbd8e3d5a9.squirrel@webmail.greenhost.nl>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 2 Mar 2011 12:52:36 +0100
Message-ID: <AANLkTinTaSpDk=89VoNrZBhCixX6dGdT4R=R9d=FG1=3@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Indan Zupancic <indan@nul.nu>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 12:32 PM, Indan Zupancic <indan@nul.nu> wrote:
> On Wed, March 2, 2011 08:44, Tejun Heo wrote:
>> On Wed, Mar 02, 2011 at 06:07:35AM +0100, Indan Zupancic wrote:
>>> I'm not sure what Denys is talking about: Currently it's impossible to
>>> pass along SIGSTOP to traced processes. Quoting the ptrace manpage:
>>>
>>>    PTRACE_CONT
>>>           Restarts  the stopped child process.  If data is nonzero and not
>>>           SIGSTOP, it is interpreted as a signal to be  delivered  to  the
>>>           child;  otherwise,  no  signal is delivered.
>>
>> AFAICS, that's not true.  SIGSTOP isn't treated differently from other
>> signals in the ptrace signal delivery path.  Maybe it was true in the
>> past.
>
> Well, I can't find it in the code either, but it's probably a side-effect
> of how ptrace is currently implemented. Test program code below, see for
> yourself. I hope it's a program bug, but perhaps it's a kernel bug, as I
> seem to get two SIGSTOP events when I allow the SIGSTOP, but only one when
> denying it.

This was discussed recently (again). Second SIGSTOP you see
is a job control stop notification (as opposed to signal delivery notification).
It's not a bug.

-- 
vda
