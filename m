Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab1ERXVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 19:21:35 -0400
Received: from smtp-out.google.com ([74.125.121.67]:28393 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902Ab1ERXVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 19:21:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bKRJiPUf85lyfK6JewWyzYAy/aa3aAali0zgtiTf3wHk+l6JTcL6Xt6b+gGRJgMj3C
         9lEfVtphyAsO1I6A5wsg==
MIME-Version: 1.0
In-Reply-To: <20110518150346.508d6406@nehalam>
References: <1305753000-14933-1-git-send-email-decot@google.com> <20110518150346.508d6406@nehalam>
From: David Decotigny <decot@google.com>
Date: Wed, 18 May 2011 16:21:10 -0700
Message-ID: <BANLkTim1iVEU_+Y2CE90Qd3+LaVch2MVOg@mail.gmail.com>
Subject: Re: [PATCH 1/2] forcedeth: make module parameters readable in /sys/module
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-net-upstream@google.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, May 18, 2011 at 3:03 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> Although this makes more info for developer, it also means more
> stuff in sysfs taking more memory and not providing any real value

Right. I'll drop this patch for now.

I do agree that this creates unnecessary pressure on some systems. But
on other systems, it is useful to know how all the loaded modules were
actually configured to track down something weird.

Regarding /sys/modules/X/parameters, the only knobs I know of are
CONFIG_SYSFS and the last argument to module_param(). If this is
correct, then it seems tricky to accommodate for both use cases above
without being crude (eg. disable sysfs, edit/sed the sources to change
last argument of module_param() macro, ...). Please correct me if I am
wrong. But if I am not, how about having a new knob allowing to
precisely control the presence/absence of /sys/module (another
CONFIG_*)? That way, the last argument to module_param() can be
interpreted as the permission when /sys/module is supported, and would
be ignored otherwise: module authors could gradually change their
perm=S_IRUGO and family without caring much about memory footprint.
And both use cases above could be supported without having to disable
sysfs altogether or change the sources.

I would be happy to work on this if it makes any sense.

Regards,
