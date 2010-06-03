Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607Ab0FCOmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:42:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36010 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab0FCOmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:42:44 -0400
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Gross\, Mark" <mark.gross@intel.com>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, "tytso\@mit.edu" <tytso@mit.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       "felipe.balbi\@nokia.com" <felipe.balbi@nokia.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>
	<201006020024.14220.rjw@sisk.pl>
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
	<1275559512.27810.35287.camel@twins>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 03 Jun 2010 07:42:37 -0700
In-Reply-To: <1275559512.27810.35287.camel@twins> (Peter Zijlstra's message of "Thu\, 03 Jun 2010 12\:05\:12 +0200")
Message-ID: <87d3w818ki.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Thu, 2010-06-03 at 11:03 +0100, Alan Cox wrote:
>> > [mtg: ] This has been a pain point for the PM_QOS implementation.
>> They change the constrain back and forth at the transaction level of
>> the i2c driver.  The pm_qos code really wasn't made to deal with such
>> hot path use, as each such change triggers a re-computation of what
>> the aggregate qos request is.
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
> Why would the kernel change the QoS state of a task? Why not have two
> interacting QoS variables, one for the task, one for the subsystem in
> question, and the action depends on their relative value?

Yes, having a QoS parameter per-subsystem (or even per-device) is very
important for SoCs that have independently controlled powerdomains.
If all devices/subsystems in a particular powerdomain have QoS
parameters that permit, the power state of that powerdomain can be
lowered independently from system-wide power state and power states of
other power domains.

Kevin
