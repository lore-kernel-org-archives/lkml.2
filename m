Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1E3TzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 15:55:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39561 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1E3TzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 15:55:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ee2bhw0i8BExmEaIhEw5BMnMgfbLVoMtPNiBMKukkI1hYHYcQfGQmkPNpSZOvxdZRi
         6sCNGb/my6UwMfdaacdh3+ajb1WCmEmolb7LxXt1Wkcv2jNKqJRysHSDXQ1kpviIg0xE
         6xiWwE1C7pZGPnTY5Bp2km0LMy4F5sUClt+oQ=
MIME-Version: 1.0
In-Reply-To: <14586.1306781002@turing-police.cc.vt.edu>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <201105231012.06928.oneukum@suse.de> <20110525000003.GJ32466@dastard>
 <201105250850.12179.oneukum@suse.de> <BANLkTincvGV735PKb60Kg0dLX6a1CZ-iNA@mail.gmail.com>
 <410B37BE-E380-40D0-82AA-48B56F389E16@mit.edu> <BANLkTimNjt4=9v33Z9Nr12xa6GmyJ-Ue5A@mail.gmail.com>
 <20110526133155.GH9520@thunk.org> <BANLkTinTzNN2P45tgZAQ9FsL43CqyAJR3Q@mail.gmail.com>
 <20110526162138.GN9520@thunk.org> <BANLkTinPCcX9-gK7YnMngGUJKftRTmYXNw@mail.gmail.com>
 <AC254312-8FFF-4070-BF8B-D9B1E8FF1AE6@mit.edu> <BANLkTi=BgGagV+dN9-nFcSkNsGNKbRMLfQ@mail.gmail.com>
 <alpine.DEB.2.02.1105291850260.5766@asgard.lang.hm> <BANLkTik69Gb2i1467bhnEU-pJ0WB10mqNQ@mail.gmail.com>
 <alpine.DEB.2.02.1105301058030.5766@asgard.lang.hm> <BANLkTimtY0ggu28i-9VzWOO1=puZ0JvcAQ@mail.gmail.com>
 <14586.1306781002@turing-police.cc.vt.edu>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Mon, 30 May 2011 21:54:34 +0200
Message-ID: <BANLkTi=e-VtedV80vWs2ZY_o1Fn2ged4jw@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Valdis.Kletnieks@vt.edu
Cc: david@lang.hm, Theodore Tso <tytso@mit.edu>,
        Oliver Neukum <oneukum@suse.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        njs@pobox.com, bart@samwel.tk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 8:43 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 30 May 2011 20:28:24 +0200, "D. Jansen" said:
>
>> I'm not really sure I why shouldn't have that choice as a user. Just
>> because someone else could be running a mailserver on his system and
>> configure it in a way that it doesn't behave as it should?
>
> It cuts both ways.  If a piece of software really wants to be sure that the
> fsync() semantics it's expecting are actually adhered to and refuses to run
> otherwise, how does it tell that you're lying to it?

Well if we allow to use a library to wrap fsync into write barriers
that doesn't seem to matter because software doesn't need to know what
happens and isn't even supposed to be able to work around it.

If this was to go into the kernel as an option, the situation was
different. But really, if you look at this discussion and the feedback
so far I don't think that's an option we need to discuss at this
point...
>
>> The big problem is that so far only fsync existed and lots of software
>> seemingly abuses it as an expensive write barrier. And it would really
>> be lovely to have the choice to stop that on an opt-in basis in laptop
>> mode.
>
> It's not "seemingly abuses it".  That's the existing userspace API for
> inserting a barrier.  The problem is that as defined, it will wait for the
> writeback to actually finish - which is actually as good as you can get without
> getting into the async I/O support.  If there was a "insert barrier and return"
> API, how would it report back that the barrier had failed with EIO after it had
> already returned to userspace?

I guess with another call some time later, to check for the success of
the previous call?
