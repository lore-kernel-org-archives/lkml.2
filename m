Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab0HEUbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:31:49 -0400
Received: from mail.lang.hm ([64.81.33.126]:49955 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934374Ab0HEUbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:31:32 -0400
Date: Thu, 5 Aug 2010 13:30:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Brian Swetland <swetland@google.com>
cc: kevin granade <kevin.granade@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <AANLkTinTBaJ7Re8E4DVmZcDAUsceUf+9jV7r67Ks=t2n@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008051326260.23543@asgard.lang.hm>
References: <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com> <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm> <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com> <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
 <20100804233013.GN24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm> <20100805001716.GO24163@linux.vnet.ibm.com> <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm> <20100805004802.GP24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm> <20100805151211.GA10080@linux.vnet.ibm.com> <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm> <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
 <AANLkTinTBaJ7Re8E4DVmZcDAUsceUf+9jV7r67Ks=t2n@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-112343616-1281040208=:23543"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-112343616-1281040208=:23543
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Thu, 5 Aug 2010, Brian Swetland wrote:

> On Thu, Aug 5, 2010 at 11:13 AM, kevin granade <kevin.granade@gmail.com> wrote:
>> IIRC, this was a major point of their (Android's) power management
>> policy.  User input of any kind would reset the "display active"
>> timeout, which is the primary thing keeping random untrusted
>> user-facing programs from being suspended while in use.  They seemed
>> to consider this to be a special case in their policy, but from the
>> kernel's point of view it is just another suspend blocker being held.
>
> The display being on should not prevent suspend unless the particular
> platform is incapable of suspending while the display is on.

if that is the case, I'll go back to my question about the untrusted 
reader app.

what is it that will prevent the system from going to sleep while I am 
reading the page?

>> I'm not sure this is the best use case to look at though, because
>> since it is user-facing, the timeout durations are on a different
>> scale than the ones they are really worried about.  I think another
>> category of use case that they are worried about is:
>>
>> (in suspend) -> wakeup due to network -> process network activity -> suspend
>>
>> or an example that has been mentioned previously:
>>
>> (in suspend) -> wakeup due to alarm for audio processing -> process
>> batch of audio -> suspend
>>
>> In both of these cases, the display may never power on (phone might
>> beep to indicate txt message or email, audio just keeps playing), so
>> the magnitude of the "timeout" for suspending again should be very
>> small.  Specifically, they don't want there to be a timeout at all, so
>> as little time as possible time is spent out of suspend in addition to
>> the time required to handle the event that caused wakeup.
>
> Yeah, we much prefer the wakelock model where the moment the resource
> (system-needing-to-not-be-suspended) is released we return to the
> lowest power state, rather than waiting for a timer to expire (and/or
> burning cycles polling for "can we suspend yet?" when we're definitely
> not ready to suspend).

at the micro level it is definantly better for power, but at the macro 
level I don't think it needs to make much difference in the overall 
battery life of the device. To borrow a phrase, I think you may be into 
premature optimization of power :-)

David Lang
--680960-112343616-1281040208=:23543--
