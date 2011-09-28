Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab1I1NEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:04:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51050 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894Ab1I1NEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:04:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
Date: Wed, 28 Sep 2011 15:04:34 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Dilan Lee <dilee@nvidia.com>, linux-arm-kernel@lists.infradead.org
References: <20110922184614.25419.84606.stgit@ponder> <20110927210849.GD3994@ponder.secretlab.ca> <20110927221308.GA2674@opensource.wolfsonmicro.com>
In-Reply-To: <20110927221308.GA2674@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281504.34560.arnd@arndb.de>
X-Provags-ID: V02:K0:E2HaWNMXlzDm7yyxnjdsCZOuTEMh85upCtTJWsfS+4G
 7JllHU16sgQBo71r8rScUECa61z8aK0Vrr1pbzaCZlYs2lyFgh
 rUjjj6zrkBA8TDVR5y5RbKxYjZLnUzxEkbvJAzFRq0tw9hHRjF
 mLdAVRlCkkZJNtPsfQUfn1wbZIraPKluqDgWC8EVt/An8KokVv
 YxxCo0eDptRaXPd7QUP2GO57SrIwG8qS9FLqSA4koIT7smz0Xl
 sX4ZBRmIyh1hmuxcew16RlPKg8/GNqzLT7u94ZzYb5NFrmTc5U
 t6sEBIVZ0XzmBzuG6wyq3Wx8v06NksUgkCPV41g9fXj5UlKn6z
 MFVgx6mqqGMnyeJAmj8k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, Mark Brown wrote:
> On Tue, Sep 27, 2011 at 03:08:49PM -0600, Grant Likely wrote:
> 
> > Okay, will do.  How does EPROBE_DEFER 518 sound?
> 
> Note that I'm not sure this answers the issue I was raising - the issue
> isn't that the caller doesn't know what the error code means, the issue
> is that in some cases the driver needs to take a decision about what
> failure to get a resource means.  Does it mean that the driver can work
> fine and be slightly less featureful or should it cause a deferral?

Can you think of cases where this information cannot be put into the
device tree or platform_data? If a board provides an optional feature,
I think that should be a property of the device that the driver gets,
so it can return an error when that feature is not around, or continue
when it knows that the feature will never become available.

	Arnd
