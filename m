Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab1FRPgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 11:36:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48251 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab1FRPgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 11:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kKviHOvOzbpoBZkY/Drhls51ND3MOaI7esz7z8ZqeXxmIH8CsPDROJ+qVmUs7KvNuw
         n6lIyM/aWMf0y4G+zKmHPQdDiFSY1VNIDOEDgeOzTkWNzuWJ5B7eRDzqenZg7fCEApav
         IL8HMsP6omMcVtK/UhXcW9VzCqYYwvcxHNCoQ=
MIME-Version: 1.0
In-Reply-To: <20110618145724.GB18190@core.coreip.homeip.net>
References: <1307706876-4768-1-git-send-email-peter.ujfalusi@ti.com>
	<5740779.B2nyl9oMW4@barack>
	<20110617094332.GE2611@htj.dyndns.org>
	<1541792.uUz2bSMDMl@barack>
	<20110618145724.GB18190@core.coreip.homeip.net>
Date: Sat, 18 Jun 2011 17:36:38 +0200
X-Google-Sender-Auth: u2LXcGw1HOBqBjzQBWZBPdO91nA
Message-ID: <BANLkTi=GpTiH3oRuEtjE0S-aZ5_V16LDnw@mail.gmail.com>
Subject: Re: Re: Re: [alsa-devel] [PATCH v4 11/18] input: Add initial support
 for TWL6040 vibrator
From: Tejun Heo <tj@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: =?ISO-8859-1?Q?P=E9ter_Ujfalusi?= <peter.ujfalusi@ti.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "Lopez Cruz, Misael" <misael.lopez@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2011/6/18 Dmitry Torokhov <dmitry.torokhov@gmail.com>:
> For my education, what is the benefit of creating a dedicated workqueue
> with alloc_workqueue (which, as far as I understand, does not end up
> having dedicated worker threads but will use the common pool) and simply
> queueing the jobs on system-wide workqueue?

In this case, nothing really, but Péter seems to want to have a
dedicated workqueue so that he can later flip HIGHPRI easily if
necessary.  Usually what a separate workqueue buys are...

* It serves as a flushing domain.  ie. You can flush work items queued
to the same workqueue together.  This is useful when individual work
items can't be flushed (e.g. they free themselves) or doing so is
inefficient.

* It serves as an attribute domain.  ie. You can set WQ_* flags and
@max_active.  If using the default values, nothing really is different
from using system_wq.

Thanks.

-- 
tejun
