Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0IUWWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:22:31 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54869 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab0IUWWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:22:30 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg KH <greg@kroah.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org
References: <m1y6b48973.fsf@fess.ebiederm.org>
	<m1eicw892p.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6>
	<20100921210809.GA28026@kroah.com>
	<alpine.LFD.2.00.1009212337030.2416@localhost6.localdomain6>
Date: Tue, 21 Sep 2010 15:21:55 -0700
In-Reply-To: <alpine.LFD.2.00.1009212337030.2416@localhost6.localdomain6>
	(Thomas Gleixner's message of "Tue, 21 Sep 2010 23:38:26 +0200
	(CEST)")
Message-ID: <m1aana3fgc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Thomas Gleixner <tglx@linutronix.de>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:

> On Tue, 21 Sep 2010, Greg KH wrote:
>
>> On Fri, Sep 17, 2010 at 10:36:50PM +0200, Thomas Gleixner wrote:
>> > On Tue, 14 Sep 2010, Eric W. Biederman wrote:
>> > 
>> > > 
>> > > register_chrdev limits uio devices to 256 minor numbers which causes
>> > > problems on one system I have with 384+ uio devices.  So instead set
>> > > UIO_MAX_DEVICES to the maximum number of minors and use
>> > > alloc_chrdev_region to reserve the uio minors.
>> > > 
>> > > The final result is that the code works the same but the uio driver now
>> > > supports any minor the idr allocator comes up with.
>> > > 
>> > > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>> > 
>> > One minor nit:
>> > 
>> > > +	result = alloc_chrdev_region(&uio_dev, 0, UIO_MAX_DEVICES, name);
>> > > +	if (result)
>> > > +		goto out;
>> > 
>> >   		return result;
>> 
>> Wait, why?  It's the exact came code, as out does:
>> 
>> out:
>> 	return result;
>> 
>> and you need that line due to the code above it.  So I say leave it.
>
> s/goto out/return result/g
>
> Gotos which end up in a single line "return foo;" are pretty
> pointless.

But they do result in a single exit, which if you insert debugging or
want to understand the code flow can sometimes be beneficial.

The compiler will make this transformation on it's own when it compiles
the code, because it does result in slightly better code.

*shrug*  In the grand scheme of things it isn't a big deal.

I'm much more interested in getting the uio driver hotplug safe so when
I physically remove a device I am using I don't get a kernel crash.

Eric
