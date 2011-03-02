Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab1CBGlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 01:41:32 -0500
Received: from swm.pp.se ([212.247.200.143]:38437 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab1CBGlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 01:41:31 -0500
Date: Wed, 2 Mar 2011 07:41:30 +0100 (CET)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: Stephen Hemminger <shemminger@vyatta.com>
cc: John Heffner <johnwheffner@gmail.com>,
        Bill Sommerfeld <wsommerfeld@google.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Albert Cahalan <acahalan@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: txqueuelen has wrong units; should be time
In-Reply-To: <20110301222531.24832a93@nehalam>
Message-ID: <alpine.DEB.1.10.1103020736260.7942@uplift.swm.pp.se>
References: <AANLkTimd5GQwtUFP2fD_An=M8ajBD8DJpzxQJezv8fB8@mail.gmail.com> <alpine.DEB.1.10.1102270758580.11974@uplift.swm.pp.se> <1298793252.8726.45.camel@edumazet-laptop> <AANLkTinyE10wtM_xJsufT_3s3hvti7CN+9nyqScWa6SA@mail.gmail.com>
 <20110227125540.40754c5y78j9u2m8@hayate.sektori.org> <AANLkTimofhhH5omyk=HhkyaNG+MGqoac4rDf=dPuR7K-@mail.gmail.com> <cbb9e1113901f1a324359b6ed3f1a611@localhost> <AANLkTikje6rvjSfEA3CvUjdgFwzk-SBZDdO5kQvi6LZy@mail.gmail.com> <AANLkTin_jY_J7tJseMLVmrQVVRezOVQTGCgB_6tefgXJ@mail.gmail.com>
 <alpine.DEB.1.10.1103010137400.7942@uplift.swm.pp.se> <20110301222531.24832a93@nehalam>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Stephen Hemminger wrote:

> It is possible to build an equivalent to WRED out existing GRED queuing
> discipline but it does require a lot of tc knowledge to get right.

To me who has worked with cisco routers for 10+ years and who is used to 
the different variants Cisco use, tc is just weird. It must come from a 
completely different school of thinking compared to what router people are 
used to, because I have tried and failed twice to do anything sensible 
with it.

> The inventor of RED (Van Jacobsen) has issues with WRED because of the 
> added complexity of queue selection. RED requires some parameters which 
> the average user has no idea how to set.

Of course there are issues and some of them can be adressed by simply 
lowering the queue depth. Yes, that might bring down the performance of 
some sessions, but for most of the interactive traffic, never buffering 
more than 40ms is a good thing.

> There are several problems with RED that prevent prevent VJ from
> recommending it in the current form.

Ask if he prefers FIFO+tail drop to RED in current form.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
