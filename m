Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab1KDW0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 18:26:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51510 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754574Ab1KDW0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 18:26:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: len.brown@intel.com, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] pm: remove useless array definition in cpuidle_structure
Date: Fri, 4 Nov 2011 23:28:43 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Robert Lee <rob.lee@linaro.org>, hpa@linux.intel.com,
        daniel.lezcano@linaro.org, amit.kucheria@linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@linaro.org
References: <1320356693-18982-1-git-send-email-rob.lee@linaro.org> <4EB3D8BE.7050600@linux.vnet.ibm.com>
In-Reply-To: <4EB3D8BE.7050600@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111042328.43358.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len, Arjan,

On Friday, November 04, 2011, Deepthi Dharwar wrote:
> On Friday 04 November 2011 03:14 AM, Robert Lee wrote:
> > From: Daniel Lezcano <daniel.lezcano@linaro.org>
> > 
> > All the modules name are ro-data, it is never copied to the array.
> > 
> > eg.
> > 
> > static struct cpuidle_driver intel_idle_driver = {
> >         .name = "intel_idle",
> >         .owner = THIS_MODULE,
> > };
> > 
> > It safe to assign the pointer of this ro-data to a const char *.
> > By this way we save 12 bytes.
> > 
> > Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > Signed-off-by: Robert Lee <rob.lee@linaro.org>
> > ---
> >  include/linux/cpuidle.h |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
> > index b51629e..16f9dce 100644
> > --- a/include/linux/cpuidle.h
> > +++ b/include/linux/cpuidle.h
> > @@ -117,8 +117,8 @@ static inline int cpuidle_get_last_residency(struct cpuidle_device *dev)
> >   ****************************/
> > 
> >  struct cpuidle_driver {
> > -	char			name[CPUIDLE_NAME_LEN];
> > -	struct module 		*owner;
> > +	const char    *name;
> > +	struct module *owner;
> >  };
> > 
> >  #ifdef CONFIG_CPU_IDLE
> 
> This looks good, and makes it fool-proof by  not allowing one to tamper the name of the driver.
> Tested OK on x86 (both Intel idle and ACPI)
> 
> Tested-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> Reviewed-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>

This is simple enough for me to push it for 3.2, but I woulnd't like to
step on anyone's toes.  Please let me know what you think.

Rafael
