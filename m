Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0FCVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 17:50:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57938 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0FCVuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 17:50:39 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6002"; a="43359912"
Message-ID: <4C0823AF.6020709@codeaurora.org>
Date: Thu, 03 Jun 2010 14:50:39 -0700
From: Bryan Huntsman <bryanh@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Gross, Mark" <mark.gross@intel.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
       Peter Zijlstra <peterz@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>,
       Neil Brown <neilb@suse.de>,
       "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Linux@smtp1.linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>	<20100601135102.GA8098@srcf.ucam.org>	<1275426085.21962.967.camel@mulgrave.site>	<201006020024.14220.rjw@sisk.pl>	<1275431816.21962.1108.camel@mulgrave.site>	<AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>	<1275451342.21962.1777.camel@mulgrave.site>	<AANLkTilRcFZyYa-0HlaM-6IEZSyar3S9S_cCWSFax2Zo@mail.gmail.com>	<1275491111.2799.110.camel@mulgrave.site>	<20100602214748.7742e3ae@schatten.dmk.lab>	<1275511271.2799.516.camel@mulgrave.site>	<20100603010607.5baf82a6@schatten.dmk.lab>	<CA1BBBBC9359F04AA639128AC0D5D1E9692ABC92@orsmsx502.amr.corp.intel.com>	<20100603110312.48a508dc@lxorguk.ukuu.org.uk>	<1275559512.27810.35287.camel@twins>	<87d3w818ki.fsf@deeprootsystems.com> <CA1BBBBC9359F04AA639128AC0D5D1E96931D4BB@orsmsx502.amr.corp.intel.com>
In-Reply-To: <CA1BBBBC9359F04AA639128AC0D5D1E96931D4BB@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Yes, having a QoS parameter per-subsystem (or even per-device) is very
>> important for SoCs that have independently controlled powerdomains.
>> If all devices/subsystems in a particular powerdomain have QoS
>> parameters that permit, the power state of that powerdomain can be
>> lowered independently from system-wide power state and power states of
>> other power domains.
>>
> This seems similar to that pm_qos generalization into bus drivers we where 
> waving our hands at during the collab summit in April?  We never did get 
> into meaningful detail at that time.
> 
> --mgross

I think there is definitely a need for QoS parameters per-device.  I've 
been pondering how to incorporate this concept into runtime_pm.  One 
idea would be to add pm_qos-like callbacks to struct dev_pm_ops, e.g. 
runtime_pm_qos_add/update/remove_requirement().  Requirements would be 
passed up the tree to the first parent that cares, usually a bus driver. 
  Is this similar to what you guys were discussing at the collab summit? 
  Thanks.

- Bryan
