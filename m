Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab0CXRF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:05:27 -0400
Received: from web94909.mail.in2.yahoo.com ([203.104.17.168]:30903 "HELO
	web94909.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751795Ab0CXRF0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:05:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=r+r+OX9JnICkt9LOffv6jTZ0FPmAWNiWk3pS9qx20s3+2A315rmlErBdk2jEzRS6uqrDetuNb7n5j3546e88Ri1lZN7gYnaoMq/ICf0kmkYaejrhT58aNo1LWgnyS7AjUvy/In23Q15Z+C+jR9sUU/v5T6wOBR4GsHdabtQWVH8=;
Message-ID: <802911.82166.qm@web94909.mail.in2.yahoo.com>
X-YMail-OSG: 63KeZEUVM1kyzWoUKTghfEHcl3n9iXfZIw7uQPdf3fXsM.b
 g7QXGcNw_WsX4UHVFzW1NgEbRf_mUVqP..z4lRztaOXIuzc7pIULLsHJiDy4
 A.Jjw4xnJ_wip8mlDVQ7fc09.Nikv9HvBQsN1M6wH_jaBznjWHRmtmrJ5bk3
 pHoIsyjIKKcJ6P5G5aNe8TCMjaJiCVO67P6s82xBTbpC1vIHR.RFQELUYwue
 pyM7aSp7xKyUGvmY4VlaWtObI0vCaUSdF7q0vuOTpVy9SIFyyiyjOwaCkxnF
 RWhAO9rZBw13TkxO11Pqsr9s-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 22:35:23 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Greg KH <gregkh@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100324165222.GA9922@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Greg KH <gregkh@suse.de> wrote:

> From: Greg KH <gregkh@suse.de>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Marcel Holtmann" <marcel@holtmann.org>, "PavanSavoy" <pavan_savoy@ti.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 10:22 PM
> On Wed, Mar 24, 2010 at 10:05:19PM
> +0530, Pavan Savoy wrote:
> > --- On Wed, 24/3/10, Greg KH <gregkh@suse.de>
> wrote:
> > 
> > > From: Greg KH <gregkh@suse.de>
> > > Subject: Re: [PATCH 4/6] drivers:misc: sources
> for Init manager module
> > > To: "Marcel Holtmann" <marcel@holtmann.org>
> > > Cc: "Pavan Savoy" <pavan_savoy@yahoo.co.in>,
> "PavanSavoy" <pavan_savoy@ti.com>,
> "alan@lxorguk.ukuu.org.uk"
> <alan@lxorguk.ukuu.org.uk>,
> "linux-kernel@vger.kernel.org"
> <linux-kernel@vger.kernel.org>
> > > Date: Wednesday, 24 March, 2010, 9:56 PM
> > > On Wed, Mar 24, 2010 at 09:11:45AM
> > > -0700, Marcel Holtmann wrote:
> > > > > I wanted to somehow put this in staging
> because
> > > then it would probably have a thorough
> architectural review
> > > process.
> > > > > Some details about this driver - 
> > > > > 
> > > > > 1. This driver will be used by
> > > Bluetooth-BlueZ/FM-V4L2 and GPS (probably
> character device
> > > driver) using the EXPORTED symbols
> (-register/_unregister).
> > > > > 
> > > > > 2. Much like the hciattach daemon which
> maintains
> > > N_HCI bluetooth line discipline, this driver will
> also have
> > > a User-Space? N_TI_WL Init manager (UIM)
> maintaining
> > > the Line discipline.
> > > > 
> > > > can you explain why you think this is needed
> and we
> > > can not interface
> > > > this directly. If it is a serial port, what
> protocol
> > > does it talk?
> > > > 
> > > > > 3. Because of the UIM should know when
> to
> > > install/uninstall line discipline, the /sys entry
> is created
> > > a root called UIM (a new kobject) and UIM daemon
> would write
> > > it's PID to it.
> > > > 
> > > > I don't understand this. This sounds like a
> broken
> > > concept to me.
> > > 
> > > I also agree, those sysfs files are not
> acceptable, and
> > > will not work
> > > as-designed due to the pid namespace issues :(
> > 
> > Ok, How do I then from kernel space, ask a user-space
> daemon to open the TTY port and do a tiocsetd on it ? 
> > [i.e ask for a line discipline to be installed ?]
> 
> What would cause the kernel to want to tell userspace to do
> this?  Is it
> an external event that happens somehow that userspace
> should know to
> look for?

Yes, Userspace events like opening the /dev/radio0 device for FM, or hci0 interface for BT.
However the apps/stack would not want to know what LDISC is being used underneath, well they might not even want to know whether it's TTY or USB/i2C - right ?

> > Can't open the TTY and TIOCSETD upon boot, because BT,
> FM and GPS
> > might be used or not used anytime.
> 
> What causes them to want to be used?  The user,
> right?
> 
> > And the idea of creating a device node, specifically
> for this and then
> > doing an fasync/SIGIO was somehow rubbished.
> 
> Why?

It does pretty much the same thing, But we would be stuffing in more interfaces to the already huge driver.
I mean just 3 fops on the device ? open/ioctl-fasync/close - but it also uses the SIGnaling concept - but not via PID though.

Alan's talking about opening up the LDISC installation to kernel (say EXPORTING tty_set_ldisc/tiocsetd), That's like ideal scenario in this case.

> 
> thanks,
> 
> greg k-h
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
