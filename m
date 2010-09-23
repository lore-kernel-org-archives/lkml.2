Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab0IWV1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 17:27:07 -0400
Received: from smtprelay02.ispgateway.de ([80.67.31.29]:45672 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0IWV1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 17:27:05 -0400
Message-ID: <4C9BC620.3@riesch.at>
Date: Thu, 23 Sep 2010 23:26:56 +0200
From: Christian Riesch <christian@riesch.at>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Christoph Lameter <cl@linux.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/8] ptp: Added a clock that uses the eTSEC found on the
 MPC85xx.
References: <cover.1285261533.git.richard.cochran@omicron.at>	<57b64051c816dc9cb856bbb9f38fc901c9d3d651.1285261535.git.richard.cochran@omicron.at>	<alpine.DEB.2.00.1009231348150.2962@router.home> <20100923214359.3f287b11@lxorguk.ukuu.org.uk>
In-Reply-To: <20100923214359.3f287b11@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Df-Sender: christian@riesch.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> Please do not introduce useless additional layers for clock sync. Load
>> these ptp clocks like the other regular clock modules and make them sync
>> system time like any other clock.
> 
> I don't think you understand PTP. PTP has masters, a system can need to
> be honouring multiple conflicting masters at once.

AFAIK the master's should not be conflicting. The Best Master Clock 
algorithm (BMC) defined in IEEE1588 selects the best master clock. This 
clock distributes its notion of time on the network while the other 
masters, that is the other clocks/nodes that are configured to 
potentially become a master, keep quiet. So usually we will only have 
one source of time (the master clock selected by the BMC) and we will 
steer our single PHC (PTP hardware clock) to follow this master (Of 
course there may be use-cases that require more than one PTP clock, 
e.g., for research purposes).

However, if the clock selected by the BMC is switched off, loses its 
network connection..., the second best clock is selected by the BMC and 
becomes master. This clock may be less accurate and thus our slave clock 
has to switch from one notion of time to another. Is that the conflict 
you mentioned?

Christian
