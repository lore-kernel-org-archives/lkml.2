Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab0LTOAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 09:00:46 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:60087 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0LTOAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 09:00:45 -0500
Date: Mon, 20 Dec 2010 14:00:32 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Mikael =?iso-8859-1?Q?Str=F6m?= <mikael@sesamiq.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Julien BLACHE <jb@jblache.org>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [lm-sensors] [PATCH 1/2 V3] applesmc: Use PnP rather than
	hardcoding resources and devices
Message-ID: <20101220140032.GA23257@srcf.ucam.org>
References: <20101217221618.GA13207@ericsson.com> <1292624661-32474-1-git-send-email-mjg@redhat.com> <20101218042320.GA14104@ericsson.com> <20101218093719.GA1493@polaris.bitmath.org> <20101218110954.7a2ca190@endymion.delvare> <20101218103139.GA1668@polaris.bitmath.org> <878vzngvyn.fsf@sonic.technologeek.org> <20101218115742.GA2063@polaris.bitmath.org> <1292852674.2118.10.camel@mike-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1292852674.2118.10.camel@mike-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 09:44:34PM +0800, Mikael Ström wrote:
> Hi,
> 
> I know nothing about the background to the mail below, but if it's of
> any help, macfanctld uses the following hardwired paths,
> 
> reading:
> 
> /sys/devices/platform/applesmc.768/temp<n>_input
> 
> and writing:
> 
> /sys/devices/platform/applesmc.768/fan1_min
> /sys/devices/platform/applesmc.768/fan2_min
> /sys/devices/platform/applesmc.768/fan1_manual
> /sys/devices/platform/applesmc.768/fan2_manual
> 
> If any of those are to be broken, please advice in advance so i can
> update the source before you break it, avoiding that the users fry their
> MacBooks.

Yes, it's very broken. Walk /sys/class/hwmon and look for an entry with 
an appropriate name, don't hardcode device paths. But given the 
breakage, it might be easier to just keep the platform device for now. 
I'll redo the patch with that in mind.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
