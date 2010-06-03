Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0FCO1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:27:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:51370 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261Ab0FCO06 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:26:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,355,1272870000"; 
   d="scan'208";a="804432957"
From: "Gross, Mark" <mark.gross@intel.com>
To: James Bottomley <James.Bottomley@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Florian Mickler <florian@mickler.org>,
       =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, "tytso@mit.edu" <tytso@mit.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>
Date: Thu, 3 Jun 2010 07:26:55 -0700
Subject: RE: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Thread-Topic: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Thread-Index: AcsDIFZ79g9ZE+R2TMSGDJ3WB3EMvQAB9Xyw
Message-ID: <CA1BBBBC9359F04AA639128AC0D5D1E96931D46D@orsmsx502.amr.corp.intel.com>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	 <20100601135102.GA8098@srcf.ucam.org>
	 <1275426085.21962.967.camel@mulgrave.site> <201006020024.14220.rjw@sisk.pl>
	 <1275431816.21962.1108.camel@mulgrave.site>
	 <AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	 <1275451342.21962.1777.camel@mulgrave.site>
	 <AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>
	 <1275491111.2799.110.camel@mulgrave.site>
	 <20100602214748.7742e3ae@schatten.dmk.lab>
	 <1275511271.2799.516.camel@mulgrave.site>
	 <20100603010607.5baf82a6@schatten.dmk.lab>
	 <CA1BBBBC9359F04AA639128AC0D5D1E9692ABC92@orsmsx502.amr.corp.intel.com>
	 <20100603110312.48a508dc@lxorguk.ukuu.org.uk>
 <1275571471.5914.2.camel@mulgrave.site>
In-Reply-To: <1275571471.5914.2.camel@mulgrave.site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: James Bottomley [mailto:James.Bottomley@suse.de]
>Sent: Thursday, June 03, 2010 6:25 AM
>To: Alan Cox
>Cc: Gross, Mark; Florian Mickler; Arve Hjønnevåg; Neil Brown;
>tytso@mit.edu; Peter Zijlstra; LKML; Thomas Gleixner; Linux OMAP Mailing
>List; Linux PM; felipe.balbi@nokia.com
>Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
>
>On Thu, 2010-06-03 at 11:03 +0100, Alan Cox wrote:
>> > [mtg: ] This has been a pain point for the PM_QOS implementation.  They
>change the constrain back and forth at the transaction level of the i2c
>driver.  The pm_qos code really wasn't made to deal with such hot path use,
>as each such change triggers a re-computation of what the aggregate qos
>request is.
>>
>> That should be trivial in the usual case because 99% of the time you can
>> hot path
>>
>> 	the QoS entry changing is the latest one
>> 	there have been no other changes
>> 	If it is valid I can use the cached previous aggregate I cunningly
>> 		saved in the top QoS entry when I computed the new one
>>
>> (ie most of the time from the kernel side you have a QoS stack)
>
>It's not just the list based computation: that's trivial to fix, as you
>say ... the other problem is the notifier chain, because that's blocking
>and could be long.  Could we invoke the notifier through a workqueue?
>It doesn't seem to have veto power, so it's pure notification, does it
>matter if the notice is delayed (as long as it's in order)?
[mtg: ] true.  The notifications "could be" done on as a scheduled work item
in most cases.  I think there is only one user of the notification so far 
any way.  Most pm_qos users do a pole of the current value for whatever parameter they are interested in.

--mgross

>
>> > We've had a number of attempts at fixing this, but I think the proper
>fix is to bolt a "disable C-states > x" interface into cpu_idle that
>bypases pm_qos altogether.  Or, perhaps add a new pm_qos API that does the
>equivalent operation, overriding whatever constraint is active.
>>
>> We need some of this anyway for deep power saving because there is
>> hardware which can't wake from soem states, which in turn means if that
>> device is active we need to be above the state in question.
>
>James
>

