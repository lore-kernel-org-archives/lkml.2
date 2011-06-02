Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1FBH3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 03:29:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755374Ab1FBH3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 03:29:46 -0400
Date: Thu, 2 Jun 2011 09:29:35 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        MyungJoo Ham <myungjoo.ham@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] PM / Runtime: Support for generic I/O power domains
 (v4)
In-Reply-To: <201105280117.17883.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1106020920360.4067@axis700.grange>
References: <201104290154.12966.rjw@sisk.pl> <201105160117.46927.rjw@sisk.pl>
 <201105280115.14556.rjw@sisk.pl> <201105280117.17883.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:nzCqnIhOocEC572NvWX0hnrc+grg9c++S9jy1kTOdE8
 U94ppQK8r4uZNzZLk9c+KgTZfQdefE2Cm+qcXQEUscOTznp5az
 U6cw6+oZG1/tiWd7hJSnT2dq/vScfHEyXdQjuxeDQnB8X0Zth7
 4K/N6TlXQS3MWe5EKOw2szS9Dk5Db59s8NsPzDUZv0pC0cxn6g
 cGt5jxgxf+O0AXqksH6ukNep582jzyek5fy7NE0urE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Introduce common headers, helper functions and callbacks allowing
> platforms to use simple generic power domains for runtime power
> management.
> 
> Introduce struct generic_power_domain to be used for representing
> power domains that each contain a number of devices and may be
> master domains or subdomains with respect to other power domains.
> Among other things, this structure includes callbacks to be
> provided by platforms for performing specific tasks related to
> power management (i.e. ->stop_device() may disable a device's
> clocks, while ->start_device() may enable them, ->power_off() is
> supposed to remove power from the entire power domain
> and ->power_on() is supposed to restore it).

I've got a generic question to this: do we have any examples of 
power-domain specific ->start_device() and ->stop_device() callbacks? A 
common case is, when these callbacks start and stop clocks, associated 
with the device, but this is not power-domain specific, right? Do we have 
any examples of different power domains in a system, having different 
these calbacks, but all devices in one power-domain, having the same ones?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
