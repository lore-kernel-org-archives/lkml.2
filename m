Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab0HXRN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:13:28 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:37109 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754406Ab0HXRN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:13:26 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 5V_dv_MVM1mZKCpvbdubGM78txHfeDg0Ym1J6CccVL_9ZxP
 uVDrfGVaqu5FYk6I80RBGCfRIEKYaRV1zWvVlFx.xjU9rlLykdKU.4yR6i9h
 WZnwCSlQxPVSaemkeWHpgh0Bn5XprTQZNUtzgsKEirtB2Woc8Igd7Z74ck6c
 BVozIZi5aqjbK.esxjQCpBeWZ4opCv.mNyIM4.8Ww0O9uMRolHCbD9diBcFs
 A5.HnoFT77DqYa9LHn8f5W44Zkx_K
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 24 Aug 2010 12:13:23 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Stan Hoeppner <stan@hardwarefreak.com>
cc: Pekka Enberg <penberg@kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: 2.6.34.1 page allocation failure
In-Reply-To: <4C72F7C6.3020109@hardwarefreak.com>
Message-ID: <alpine.DEB.2.00.1008241210570.3695@router.home>
References: <4C70BFF3.8030507@hardwarefreak.com> <alpine.DEB.1.10.1008220842400.8562@uplift.swm.pp.se> <AANLkTin48SJ58HvFqjrOnQBMqLcbECtqXokweV00dNgv@mail.gmail.com> <alpine.DEB.2.00.1008221734410.21916@router.home> <4C724141.8060000@kernel.org>
 <4C72F7C6.3020109@hardwarefreak.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Stan Hoeppner wrote:

> Should I be using SLUB instead?  Any downsides to SLUB on an old and
> slow (500 MHz) single core dual CPU box with <512MB RAM?

SLUB has a smaller memory footprint so you may come out ahead for
such a small system in particular.

> Also, what is the impact of these oopses?  Despite the entries in dmesg,
> the system "seems" to be running ok.  Or is this simply the calm before
> the impending storm?

The system does not guarantee that GFP_ATOMIC allocation succeed so any
caller must provide logic to fall back if no memory is allocated. So the
effect may just be that certain OS operations have to be retried.


