Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab1K0XH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 18:07:26 -0500
Received: from gate.crashing.org ([63.228.1.57]:34850 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929Ab1K0XHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 18:07:25 -0500
Message-ID: <1322435233.23348.19.camel@pasglop>
Subject: Re: [RFC PATCH v2 4/4] cpuidle: (POWER) Handle power_save=off
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-pm@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Nov 2011 10:07:13 +1100
In-Reply-To: <20111117112906.9191.54050.stgit@localhost6.localdomain6>
References: <20111117112815.9191.2322.stgit@localhost6.localdomain6>
	 <20111117112906.9191.54050.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 16:59 +0530, Deepthi Dharwar wrote:
> This patch makes pseries_idle_driver not to be registered when
> power_save=off kernel boot option is specified. The
> boot_option_idle_override variable used here is similar to
> its usage on x86.

Quick Q. With your changes, the CPU will never get into idle at all
until cpuidle initializes and the driver loads.

That means not only much later in the boot process, but potentially
never if the distro has the driver as a module and fails to load it, or
similar.

Can't that be an issue ? Shouldn't we keep at least one of the basic
idle functions as a fallback ?

Cheers,
Ben.


