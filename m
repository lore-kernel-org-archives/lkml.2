Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab1LBOn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 09:43:56 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:24340 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756742Ab1LBOnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 09:43:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 39ChMjQVM1kUFzvjkBW1mlxg8ty8Vi8FUbmec1OlSr3vs2q
 BDrBMcbJmqFODGQN_SqT4urVN9xCMVikITj7S1Rzr8173s_gycb47ur7SPnV
 icmYtowdEq6X2BSvBziU.4YWpQbPW8Nb51UqTAMn1Frcr3O2ZrUbRInmClbe
 dYvvJgxwngJhpb8J9KaR1Phf9vNrwTcf7ofpVLUL1KVpos0ehBi.gKonmpwP
 FivfdCPu6TMD1VECwfDy1x8K4WlpRxkbMxUls3LWGUO1sc4dGqwiReEgZYrq
 RSnX8WSsWi_isIvPJWqvwBVX8dzB4UR0V32pog._tob2j1mSSMZFFLD95VtU
 eD.kFAsoDUsNbuFJVYGixadG7NLmxro8vtv1av0whsuFhPC2NtB8.GsLre4o
 8gWUZoXk7a0BJULeYs6Fwgg--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 2 Dec 2011 08:43:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Alex Shi <alex.shi@intel.com>
cc: penberg@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
Message-ID: <alpine.DEB.2.00.1112020842280.10975@router.home>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Dec 2011, Alex Shi wrote:

> From: Alex Shi <alexs@intel.com>
>
> Times performance regression were due to slub add to node partial head
> or tail. That inspired me to do tunning on the node partial adding, to
> set a criteria for head or tail position selection when do partial
> adding.
> My experiment show, when used objects is less than 1/4 total objects
> of slub performance will get about 1.5% improvement on netperf loopback
> testing with 2048 clients, wherever on our 4 or 2 sockets platforms,
> includes sandbridge or core2.

The number of free objects in a slab may have nothing to do with cache
hotness of all objects in the slab. You can only be sure that one object
(the one that was freed) is cache hot. Netperf may use them in sequence
and therefore you are likely to get series of frees on the same slab
page. How are other benchmarks affected by this change?
