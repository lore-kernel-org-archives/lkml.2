Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab1AKACr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 19:02:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab1AKACp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 19:02:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] cpuidle: Make cpuidle_enable_device() call poll_idle_init()
Date: Tue, 11 Jan 2011 01:02:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>
References: <201101080029.20744.rjw@sisk.pl> <alpine.LFD.2.02.1101101754320.7945@x980>
In-Reply-To: <alpine.LFD.2.02.1101101754320.7945@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101110102.22204.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 11, 2011, Len Brown wrote:
> >  /**
> >   * cpuidle_enable_device - enables idle PM for a CPU
> >   * @dev: the CPU
> > @@ -176,6 +215,8 @@ int cpuidle_enable_device(struct cpuidle
> >  		ret = __cpuidle_register_device(dev);
> >  		if (ret)
> >  			return ret;
> > +	} else {
> > +		poll_idle_init(dev);
> >  	}
> 
> how about calling poll_idle_init() unconditionally here
> and deleting the call to it from within __cpuidle_register_device()?

Fine by me, as long as poll_idle_init() is called before the conditional. :-)

Thanks,
Rafael
