Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0E1WX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 18:23:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54329 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab0E1WXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 18:23:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Date: Sat, 29 May 2010 00:24:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rjw; KDE/4.3.5; x86_64; ; )
Cc: Florian Mickler <florian@mickler.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>, Paul@smtp1.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <Pine.LNX.4.44L0.1005271253240.3239-100000@iolanthe.rowland.org> <20100528104415.1403541a@schatten.dmk.lab> <AANLkTikXtk-f41-z8gXfXLNLqgGVa0z4d-qgIvwljbR-@mail.gmail.com>
In-Reply-To: <AANLkTikXtk-f41-z8gXfXLNLqgGVa0z4d-qgIvwljbR-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201005290024.22915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 May 2010, Arve Hjønnevåg wrote:
> On Fri, May 28, 2010 at 1:44 AM, Florian Mickler <florian@mickler.org> wrote:
> > On Thu, 27 May 2010 20:05:39 +0200 (CEST)
> > Thomas Gleixner <tglx@linutronix.de> wrote:
...
> > To integrate this with the current way of doing things, i gathered it
> > needs to be implemented as an idle-state that does the suspend()-call?
> >
> 
> I think it is better no not confuse this with idle. Since initiating
> suspend will cause the system to become not-idle, I don't think is is
> beneficial to initiate suspend from idle.

It is, if the following two conditions hold simultaneously:

(a) Doing full system suspend is ultimately going to bring you more energy
    savings than the (presumably lowest) idle state you're currently in.

(b) You anticipate that the system will stay idle for a considerably long time
    such that it's worth suspending.

Thanks,
Rafael
