Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1CBQw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:52:26 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60452 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1CBQwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:52:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pYDrIpuceIu2LUSBa3yizBC7+L+DRKi4g4inKcEnlkxvZJXq65If79Cg7GRdfbG1v8
         99lJTukSqS6SJWSCp7q+uMSKfEicnbBMWVJ1kvdV+wz2GZgXYpXyV3/8WIw+zvUE+eQ2
         Q6hcpzCkuqUIRBrbL/fwkBFzuFGzJmQ9mMOkU=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        John Heffner <johnwheffner@gmail.com>,
        Bill Sommerfeld <wsommerfeld@google.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Albert Cahalan <acahalan@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.1103021739550.7942@uplift.swm.pp.se>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com>
	 <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se>
	 <1298793252.8726.45.camel@edumazet-laptop>
	 <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
	 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org>
	 <AANLkTimofhhH5omyk=HhkyaNG+MGqoac4rDf=dPuR7K-@mail.gmail.com>
	 <cbb9e1113901f1a324359b6ed3f1a611@localhost>
	 <AANLkTikje6rvjSfEA3CvUjdgFwzk-SBZDdO5kQvi6LZy@mail.gmail.com>
	 <AANLkTin_jY_J7tJseMLVmrQVVRezOVQTGCgB_6tefgXJ@mail.gmail.com>
	 <alpine.DEB.1.10.1103010137400.7942@uplift.swm.pp.se>
	 <20110301222531.24832a93@nehalam>
	 <alpine.DEB.1.10.1103020736260.7942@uplift.swm.pp.se>
	 <20110301230754.5ef4ab35@nehalam>
	 <alpine.DEB.1.10.1103021739550.7942@uplift.swm.pp.se>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 17:50:44 +0100
Message-ID: <1299084644.2920.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 mars 2011 à 17:41 +0100, Mikael Abrahamsson a écrit :
> On Tue, 1 Mar 2011, Stephen Hemminger wrote:
> 
> > Also WRED is not default on faster links because it can't be done fast 
> > enough.
> 
> Before this propagates as some kind of truth. Cisco modern core routers 
> have no problems doing WRED at wirespeed, the above statement is not true.
> 

looking at cisco docs you provided
( <http://www.cisco.com/en/US/docs/ios/12_0s/feature/guide/12stbwr.html>
 )
, it seems the WRED time limits (instead of bytes/packets limits) are
internaly converted to bytes/packets limits


quote : 

When the queue limit threshold is specified in milliseconds, the number
of milliseconds is internally converted to bytes using the bandwidth
available for the class. 


So it seems its only a facility provided, and queues are still managed
with bytes/packets limits...

WRED is able to prob drop a packet when this packet is enqueued. At time
of enqueue, we dont know yet the time of dequeue, unless bandwidth is
known.



