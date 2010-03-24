Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0CXQfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:35:23 -0400
Received: from web94909.mail.in2.yahoo.com ([203.104.17.168]:24192 "HELO
	web94909.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756227Ab0CXQfW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:35:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MOZ2O1RJuUjtU5VjmIwbN/txBUz4bCtf8l1MNeAg655AiIPJlNZ9UaZZCPQLNauLITQA8p9QJYs/cayWr7nNskq9LIPLijQXBeFOlW8ceTq9IrCx2c8513Lks1f+qyWKz9IIyAsP+MXLjJNiysge+qgPqrxDbKSnT22pBYgR6gk=;
Message-ID: <749404.60454.qm@web94909.mail.in2.yahoo.com>
X-YMail-OSG: h8I24AAVM1klXyAchuuoZJ0MdLao0QOaq9fXdmuyLNOAYMo
 RF7ebYWjyJu3sXfplBpiMNjzU_YPcaaqxV4RKwTcjobg75uiBI1YB3B_Ghbt
 6vk3eufL36.5qzQwyoqgyKCMDuc54afj5UxKvxGkYYPEAhucVe4bU0fXsJEG
 _foRj5YaJcVrfRRHiiZbi8AXEh6CZX0ELpLceus20Sh7WryxSa7br4lGgxiD
 IcKhS689ejH8DpF6F.L2mSL4dLU7aScTqKYZAj.EXoKdF8myIv3ULQvfMcnF
 4i5umMFenRJMWUB8FNfCCbdk-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 22:05:19 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>
Cc: PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20100324162616.GA9257@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Greg KH <gregkh@suse.de> wrote:

> From: Greg KH <gregkh@suse.de>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Marcel Holtmann" <marcel@holtmann.org>
> Cc: "Pavan Savoy" <pavan_savoy@yahoo.co.in>, "PavanSavoy" <pavan_savoy@ti.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 9:56 PM
> On Wed, Mar 24, 2010 at 09:11:45AM
> -0700, Marcel Holtmann wrote:
> > > I wanted to somehow put this in staging because
> then it would probably have a thorough architectural review
> process.
> > > Some details about this driver - 
> > > 
> > > 1. This driver will be used by
> Bluetooth-BlueZ/FM-V4L2 and GPS (probably character device
> driver) using the EXPORTED symbols (-register/_unregister).
> > > 
> > > 2. Much like the hciattach daemon which maintains
> N_HCI bluetooth line discipline, this driver will also have
> a User-Space  N_TI_WL Init manager (UIM) maintaining
> the Line discipline.
> > 
> > can you explain why you think this is needed and we
> can not interface
> > this directly. If it is a serial port, what protocol
> does it talk?
> > 
> > > 3. Because of the UIM should know when to
> install/uninstall line discipline, the /sys entry is created
> a root called UIM (a new kobject) and UIM daemon would write
> it's PID to it.
> > 
> > I don't understand this. This sounds like a broken
> concept to me.
> 
> I also agree, those sysfs files are not acceptable, and
> will not work
> as-designed due to the pid namespace issues :(

Ok, How do I then from kernel space, ask a user-space daemon to open the TTY port and do a tiocsetd on it ? 
[i.e ask for a line discipline to be installed ?]

Can't open the TTY and TIOCSETD upon boot, because BT, FM and GPS might be used or not used anytime.

And the idea of creating a device node, specifically for this and then doing an fasync/SIGIO was somehow rubbished.

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
