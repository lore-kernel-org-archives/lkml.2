Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0HHMxz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 08:53:55 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50000 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000Ab0HHMxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 08:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=vuVDYAKhheTJr6qpxsbYqTpEazMpj4ysXEs/Hp/6X9m+O8P495QfmEA2sucoq13K+S
         dGn6yivgjIh/JGiLzAvSc2Wvlf0z30tLIMU22ThTvoNHyHO83fjW3FJbvEsnlyGoEWXa
         8jKxaSbLewvPZ82fwbrjvAREn29EIzlsq2GjQ=
MIME-Version: 1.0
In-Reply-To: <20100807061558.GA28087@thunk.org>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
Date: Sun, 8 Aug 2010 15:53:52 +0300
Message-ID: <AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, david@lang.hm,
        Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 7, 2010 at 9:15 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Aug 06, 2010 at 08:14:09PM -0700, david@lang.hm wrote:
>> 1. sleeping can't currently save as much power as suspending
>
> No, I don't think that's the case at all.  The key thing here is that
> *most* applications don't need to be modified to use suspend locks,
> because even though they might be in an event loop, when the user user
> turns off the display, the user generally doesn't want it doing things
> on their behalf.

You are overgeneralizing; there are many applications that run in the
background, and you want to keep them running even when the display is
off.

You seen to be concentrating on UI-only applications, for those it's
worth noting that Android provides separate mechanisms for power
saving. Since Android doesn't have true multi-tasking, the
applications must serialize their states so that the next time they
are opened they seem to have not been closed. So, the current active
UI application can be closed while turning off the display, and
re-opened later.

User-space suspend blockers are relevant for background services, and
as it has been discussed before; suspend blockers (not activating
them) might actually degrade power usage.

-- 
Felipe Contreras
