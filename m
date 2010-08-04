Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab0HDWzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 18:55:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:45834 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757556Ab0HDWzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 18:55:07 -0400
Date: Wed, 4 Aug 2010 15:54:16 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Pavel Machek <pavel@ucw.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <20100804204839.GA4743@srcf.ucam.org>
Message-ID: <alpine.DEB.2.00.1008041543030.6545@asgard.lang.hm>
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100731230101.7cc1d8c7@infradead.org> <20100801191228.GL2470@linux.vnet.ibm.com> <20100801154708.19817b75@infradead.org> <20100802011006.GS2470@linux.vnet.ibm.com> <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
 <20100803183447.0275c134@infradead.org> <20100804163216.GB24163@linux.vnet.ibm.com> <20100804163509.GA31523@srcf.ucam.org> <20100804204208.GA21452@elf.ucw.cz> <20100804204839.GA4743@srcf.ucam.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Aug 2010, Matthew Garrett wrote:

> On Wed, Aug 04, 2010 at 10:42:08PM +0200, Pavel Machek wrote:
>
>> This came like a bit of a shock to me ("why do they make it so complex
>> then"), but... it also means that as soon as you are able to stop
>> "unwanted" processing, you can just leave normal cpuidle mechanisms to
>> deal with the rest...
>
> How do you differentiate between "unwanted" and "wanted" processing in
> the same task in a race-free manner?

how much do you care? (not from a theoretical point of view, but from a 
practical point of view, how much difference does it make)

how much "unwanted" processing would you allow a process to do before 
shutting down?

how likely are apps that you would trust to just assert "I know better 
than the system or the user how important I am, don't you dare sleep now" 
that do this properly, but then do other processing that you really don't 
want to have happen? (I expect that if the authors of those apps ever ran 
into this case, they would just add another wakelock to prevent it)


If the only things you have running are apps that are trusted to take the 
wakelock, are you really going to sleep any more frequently with the 
wakelock infrastructure than you would with just idle detection? (this can 
be tested today by just stubbing out the wakelock checks so they have no 
effect on sleeping)


David Lang
