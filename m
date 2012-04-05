Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2DEKlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 06:41:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43432 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab2DEKlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 06:41:31 -0400
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
Thread-Index: AQHNEWH/ogbkcH+7O02pQ5jFyo8I/ZaIgNYAgAN273A=
Date: Thu, 5 Apr 2012 10:40:55 +0000
Message-ID: <6F6B80BD2E18844D97BB4B51FE3705C831790EA0@DBDE01.ent.ti.com>
References: <1333433022-5455-1-git-send-email-akshay.s@ti.com>
 <20120403105530.7fa3bce7@pyramind.ukuu.org.uk>
In-Reply-To: <20120403105530.7fa3bce7@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 03, 2012 at 15:25:30, Alan Cox wrote:
> > This patch was submitted 2 years ago but didn't make it to the mainline. Now i am reposting it.
> 
> Can you fix it instead of just reposting it ?
> 
> 
> > +#ifdef CONFIG_CPU_FREQ
> > +static int serial8250_cpufreq_transition(struct notifier_block *nb,
> > +					     unsigned long val, void *data)
> > +{
> > +	struct uart_8250_port *p;
> > +	struct uart_port *uport;
> 
> What is your locking model ?
> 

I will have a look at this and add the lock if necessary.

> 
> > +static inline void serial8250_cpufreq_deregister(struct uart_8250_port *p)
> 
> unregister

Ok. I will change it.

> 
> > +		ret = serial8250_cpufreq_register(uart);
> > +		if (ret < 0)
> > +			printk(KERN_ERR "Failed to add cpufreq notifier\n");
> 
> Why do this for devices that don't care.

This is taken care in the code. If the device's frequency doesn't change after the
change in the cpu frequency then it doesn't go for execution of the function "serial8250_set_termios".
It does execute only if the uart clk frequency is changed with a change in the cpu frequency. 
So registering this for the devices that doesn't care will not affect the system. 


Regards,
Akshay
    
 
