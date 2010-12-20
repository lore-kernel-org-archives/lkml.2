Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab0LTOYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:24:45 -0500
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:60068 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757373Ab0LTOYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:24:44 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 20 Dec 2010 15:23:44 +0100
To: Jean Delvare <khali@linux-fr.org>
Cc: Mikael =?iso-8859-1?Q?Str=F6m?= <mikael@sesamiq.com>,
        Julien BLACHE <jb@jblache.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
 hardcoding resources and devices
Message-ID: <20101220142344.GA19566@polaris.bitmath.org>
References: <20101217221618.GA13207@ericsson.com>
 <1292624661-32474-1-git-send-email-mjg@redhat.com>
 <20101218042320.GA14104@ericsson.com>
 <20101218093719.GA1493@polaris.bitmath.org>
 <20101218110954.7a2ca190@endymion.delvare>
 <20101218103139.GA1668@polaris.bitmath.org>
 <878vzngvyn.fsf@sonic.technologeek.org>
 <20101218115742.GA2063@polaris.bitmath.org>
 <1292852674.2118.10.camel@mike-laptop>
 <20101220145721.4c58ff3e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101220145721.4c58ff3e@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Originating-IP: 83.248.200.95
X-Scan-Result: No virus found in message 1PUgf0-0004TB-Bs.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PUgf0-0004TB-Bs 89589fcc2ae9dc099c55370ab3387655
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 02:57:21PM +0100, Jean Delvare wrote:
> On Mon, 20 Dec 2010 21:44:34 +0800, Mikael Ström wrote:
> > Hi,
> > 
> > I know nothing about the background to the mail below, but if it's of
> > any help, macfanctld uses the following hardwired paths,
> > 
> > reading:
> > 
> > /sys/devices/platform/applesmc.768/temp<n>_input
> > 
> > and writing:
> > 
> > /sys/devices/platform/applesmc.768/fan1_min
> > /sys/devices/platform/applesmc.768/fan2_min
> > /sys/devices/platform/applesmc.768/fan1_manual
> > /sys/devices/platform/applesmc.768/fan2_manual
> > 
> > If any of those are to be broken, please advice in advance so i can
> > update the source before you break it, avoiding that the users fry their
> > MacBooks.
> 
> I would expect the kernel driver to behave sanely in the absence of a
> user-space application. Isn't it the case? If not, I consider it a
> serious bug in the driver, which should be addressed ASAP.

The macbook overheat problems goes way back. All models have automatic
heat protection, but it kicks in at temperatures uncomfortable to most
users. The severity also depends on when the model was made. The
current solution is to use the macfanctld driver, which disables
automatic fan control, replacing it with a control loop yielding more
workable temperatures. A fan control solution in the kernel would
certainly be well received.

Henrik
