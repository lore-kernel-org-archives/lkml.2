Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab2JBJbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:31:33 -0400
Received: from listserv2.niif.hu ([193.225.14.155]:52074 "EHLO
	listserv2.niif.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2JBJba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:31:30 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: "Michael Chan" <mchan@broadcom.com>
Cc: netdev@vger.kernel.org, "Matt Carlson" <mcarlson@broadcom.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: Re: tg3 driver upgrade (Linux 2.6.32 -> 3.2) breaks IBM Bladecenter SoL
References: <87txuhho5z.fsf@lant.ki.iif.hu>
	<1349083982.5420.16.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
Date: Tue, 02 Oct 2012 11:31:02 +0200
In-Reply-To: <1349083982.5420.16.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	(Michael Chan's message of "Mon, 1 Oct 2012 02:33:02 -0700")
Message-ID: <87sj9xdxux.fsf@lant.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Chan" <mchan@broadcom.com> writes:

> On Fri, 2012-09-28 at 22:45 +0200, Ferenc Wagner wrote: 
> 
>> Upgrading the kernel on our HS20 blades resulted in their SoL (serial
>> over LAN) connection being broken.  The disconnection happens when eth0
>> (the interface involved in SoL) is brought up during the boot sequence.
>> If I later "ip link set eth0 down", then the connection is restored, but
>> "ip link set eth0 up" breaks it again on 3.2.  ethtool -a, -c, -g, -k
>> and -u show no difference; ethtool -i on the 2.6.32 kernel reports:
>> 
>> driver: tg3
>> version: 3.116
>> firmware-version: 5704s-v3.38, ASFIPMIs v2.47
>> bus-info: 0000:05:01.0
>> 
>> In the 3.2 kernel the driver version is 3.121.
>
> 2.6.32 to 3.2 is a big jump.  Can you narrow this down further?  It will
> be hard for us to find a HS20 with 5704 to test this.  Thanks.

Certainly, I'm bisecting it now, but I thought I would drop in the
question in case it rings some bells somewhere.  Given the nature of the
problem, it isn't much fun to bisect, and the stripped down kernel I'm
testing with breaks the SoL connection for a couple of seconds even in
the "good" cases.  I'm already down to 13 steps...
-- 
Thanks,
Feri.
