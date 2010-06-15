Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab0FORZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 13:25:45 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48667 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099Ab0FORZo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 13:25:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=HqU3Gn3JFfqu20r6OwELn8TouV3MtheYSolyPj9slhPAvN+MoXj8EUY/ikTokw8fyT
         wr87c1uE+etCjMeIgvGR14fGw71blBdvTw37RhxHBmk1LN1If1AxG4e27AEQS2HKUFMq
         hP+12SSe4ZPY7ei09kyGw/KMxu8BZoV9MwQQE=
MIME-Version: 1.0
In-Reply-To: <20100614214646.GF6666@thunk.org>
References: <E1OMQ88-0002a1-Gb@closure.thunk.org>
	<AANLkTilqc0jpwnIwe3OIQvB9avaXXzrBK4Hz0huESygy@mail.gmail.com>
	<20100613194949.GC8055@thunk.org>
	<AANLkTilQLk7ofSJBm9KIa2g1KQ35GC1D1vOZlPrv1VRv@mail.gmail.com>
	<20100614184244.GA11480@elliptictech.com>
	<20100614214646.GF6666@thunk.org>
Date: Tue, 15 Jun 2010 18:25:42 +0100
X-Google-Sender-Auth: PbHSKff5OIaKM8LAaVtT_C6Nbzg
Message-ID: <AANLkTikxOwYQYSzNjEqRduTQvoUandnAsZzm5Auzgnaz@mail.gmail.com>
Subject: Re: Why is kslowd accumulating so much CPU time?
From: Andy Whitcroft <apw@canonical.com>
To: tytso@mit.edu, Dave Airlie <airlied@gmail.com>,
       Dave Airlie <airlied@redhat.com>, David Howells <dhowells@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 10:46 PM,  <tytso@mit.edu> wrote:
> On Mon, Jun 14, 2010 at 02:42:44PM -0400, Nick Bowler wrote:
>>
>> This sounds exactly like the issue I've been seeing on a T500 laptop, as
>> well (GM45 board).  The slowdowns render the system essentially
>> unusable, as it can spend a loooong time just moving the mouse cursor a
>> few pixels on the screen.  During this time, nothing else on the display
>> is updating (glxgears drops to 0fps).  Things generally seem to be
>> working fine if I am not moving the mouse, or if I'm not running X.
>
> I saw exactly the same behaviour when using the Ubuntu Karmic
> userspace.  Basically, using a 2.6.35-rc2 (+ vt memory corrupter fix)
> kernel, the system was essentially unusable.  Interestingly, the
> problem went away (with the same kernel) once I updated to Ubuntu
> Lucid.  I was going to mention that so that hopefully someone with far
> more X.org-fu than I could figure out how much of this is a X server
> bug, and how much of this was a kernel bug, but things worked just
> *fine* with 2.6.34 kernel.
>
> Occasionally it will happen that the mouse stops tracking, and then I
> grumble and curse, and a few seconds later it resolves itself.  I
> haven't had time to track it down; but the problem was breathtakingly
> easy to reproduce with an Ubuntu Karmic userspace.  :-)

I am seeing crunchy cursor behavior on boot on Ubuntu Lucid user space
with the 2.6.35-rc3 kernel as well.  It pretty much always does that
on boot, and often later as well.  Right now I have four of these
chaps each consuming 9% of a CPU.  Though they definatly come and go.
Very odd:

  938 root      15  -5     0    0    0 S    9  0.0   1:00.90 kslowd001
 1048 root      15  -5     0    0    0 S    9  0.0   1:01.12 kslowd002
  937 root      15  -5     0    0    0 S    8  0.0   1:00.92 kslowd000
 1544 root      15  -5     0    0    0 D    8  0.0   1:00.55 kslowd003

-apw
