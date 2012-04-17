Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2DQJnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 05:43:52 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44074 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab2DQJnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 05:43:49 -0400
From: "Shankarmurthy, Akshay" <akshay.s@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] serial: 8250: Add cpufreq support
Thread-Topic: [PATCH] serial: 8250: Add cpufreq support
Thread-Index: AQHNEWH/ogbkcH+7O02pQ5jFyo8I/ZaIgNYAgAN273D//73mAIAK/Rkg///w8wCACAtT4A==
Date: Tue, 17 Apr 2012 09:43:30 +0000
Message-ID: <6F6B80BD2E18844D97BB4B51FE3705C83E92A183@DBDE01.ent.ti.com>
References: <1333433022-5455-1-git-send-email-akshay.s@ti.com>
	<20120403105530.7fa3bce7@pyramind.ukuu.org.uk>
	<6F6B80BD2E18844D97BB4B51FE3705C831790EA0@DBDE01.ent.ti.com>
	<20120405115322.15e6088c@pyramind.ukuu.org.uk>
	<6F6B80BD2E18844D97BB4B51FE3705C83179146B@DBDE01.ent.ti.com>
 <20120412104758.3fc8085d@pyramind.ukuu.org.uk>
In-Reply-To: <20120412104758.3fc8085d@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 15:17:58, Alan Cox wrote:
> > > > I will have a look at this and add the lock if necessary.
> > > 
> > > At the very least you need reference counts held on the tty struct and to allow for the tty having vanished under you.
> > > 
> > 
> > I am planning to add "tty->termios_mutex" lock. Any comments ?
> 
> Explain how this will help. You need a reference count to the tty itself.
> 


I have gone through the serial driver, still I am not able to figure out the requirement
of tty reference count here. Correct me if I am wrong. 
As per my understanding, tty count keeps the count of tty_open and tty_release, that is
how many open and close happened on the tty device file(/dev/ttyS*).
The requirement here is a tty count check, if it is greater than zero then only it should
proceed for further execution. 
Kindly elaborate more on the same if it's not correct.

> 
> Alan
> 

