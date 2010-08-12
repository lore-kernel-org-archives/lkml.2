Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759616Ab0HLAX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:23:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48044 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758663Ab0HLAXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:23:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sxArHPYjgAIW9WhM/HjJHww5cRgsKNonb3bgVyY9saOLcl6SxxQO3Y4QeIxPqkUApF
         SWYhsjbCxmb1tcgWnJqR+h3DMwjktd+pAu+e9LSaebGigW8pe/uhQzIoG4xIPO7hTUlJ
         /cjs7kQGTyCpMwRbupXPLK8rQHuOK+m53Nm6Y=
MIME-Version: 1.0
In-Reply-To: <EA6E0E5D-0F18-4F9A-BB39-11958E82BC69@opensource.wolfsonmicro.com>
References: <alpine.DEB.2.00.1008051800360.25170@asgard.lang.hm>
	<20100806123047.GE31326@sirena.org.uk>
	<20100806172226.GH2432@linux.vnet.ibm.com>
	<20100806173325.GA25367@rakim.wolfsonmicro.main>
	<20100806181832.GJ2432@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061517130.30564@asgard.lang.hm>
	<20100807001431.GA3252@opensource.wolfsonmicro.com>
	<alpine.DEB.2.00.1008061741460.30564@asgard.lang.hm>
	<20100807062828.GB28087@thunk.org>
	<AANLkTinTfKRfAUJqggcK9Cgo9BTXfqMjJ2SXZS=D1bmT@mail.gmail.com>
	<20100808160810.GA7968@srcf.ucam.org>
	<AANLkTik3FN5tTO8sgwz32b8s2SLnc8D1=14yU-a2betp@mail.gmail.com>
	<EA6E0E5D-0F18-4F9A-BB39-11958E82BC69@opensource.wolfsonmicro.com>
Date: Thu, 12 Aug 2010 03:23:44 +0300
Message-ID: <AANLkTi=yqnOdsJvq8dYmCjS6Ja758d9y+CUAHG069Mmd@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, "Ted Ts'o" <tytso@mit.edu>,
        "david@lang.hm" <david@lang.hm>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Brian Swetland <swetland@google.com>,
        kevin granade <kevin.granade@gmail.com>,
        "Arve Hj?nnev?g" <arve@android.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "florian@mickler.org" <florian@mickler.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 8, 2010 at 9:34 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On 8 Aug 2010, at 18:08, Felipe Contreras <felipe.contreras@gmail.com> wrote:
>
>> On Sun, Aug 8, 2010 at 7:08 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
>>> It's clearly possible for a pathological Android application to destroy
>>> the power management policy. But to do that, the author would have to
>>> explicitly take a wakelock. That's difficult to do by accident.
>>
>> The writer can take a wakelock the whole time the application is
>> running (isn't that the typical case?), because perhaps the author
>> realizes that way the application works correctly, or he copy-pasted
>> it from somewhere else.
>
> That would be exceptionally unusual. A more common case is that the application will take a wakelock while performing some specific long running task which needs no user intervention such as downloading a file or displaying constantly update status that the user is not expected to respond to. There's no need for applications to take wakelocks while the user is directly interacting with them since the system will be kept awake as a result of the user interaction, the wakelocks are used to override the default suspend that occurs when the user is not interacting with the device.

Fair enough, but if that the case, if suspend blockers are to be used
in desktop software, everything would need extensive modifications
just to work. I remember somebody said that was not the case, I
thought it was because the lock could be held the whole time the
application is running.

-- 
Felipe Contreras
