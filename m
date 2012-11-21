Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2KUJyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:54:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:51625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab2KUJyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:54:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH V4 1/3] of: introduce for_each_matching_node_and_match()
Date: Wed, 21 Nov 2012 09:53:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Olof Johansson <olof@lixom.net>,
        Josh Cartwright <josh.cartwright@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
References: <1353453142-4973-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1353453142-4973-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211210953.20552.arnd@arndb.de>
X-Provags-ID: V02:K0:drhSzqT/w5s0SR4SIv1qM6LEx8BPgJHqJgKziMpPDq1
 //4+cwBSUmFYgg2lXqPA17j1tNtOQ+v/RcldV9egVii3afc2Rj
 yjJ6U4v2kvWp4XAEzgLHX+klo/oR1bo/4dP5Pl/ytaM4+psmCh
 Rd/XyM/WwBpGlWqKKe/h1fmmVRJL2U3WCEKn17uCLw3xKkWy8F
 MsJOwvJehhP/C3vgvDC4F+B7wS/ptA8qp3/HNqkeXionr3zu3P
 rGv32KUI1+ZX/SDlYoEAjnPNqa0k+6A5GKGiH4W0Z2dQSLHfid
 FKcBWHGMNBjnSUqaZYih1gQNbuezzRifwPVPd16L756BukCjJU
 VQ5D+P7Mxd/0yLXal78s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012, Stephen Warren wrote:
> However, this results in iterating over table twice; the second time
> inside of_match_node(). The implementation of for_each_matching_node()
> already found the match, so this is redundant. Invent new function
> of_find_matching_node_and_match() and macro
> for_each_matching_node_and_match() to remove the double iteration,
> thus transforming the above code to:
> 
>     for_each_matching_node_and_match(np, table, &match)
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

This look useful, but I wonder if the interface would make more sense if you
make the last argument to the macro a normal pointer, rather than a
pointer-to-pointer. You can take the reference as part of the macro.

	Arnd
