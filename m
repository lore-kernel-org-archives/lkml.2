Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757814Ab2CUPTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:19:07 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:1539 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068Ab2CUPTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:19:05 -0400
Date: Wed, 21 Mar 2012 16:18:51 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Eric Paris <eparis@parisplace.org>
Cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] thermal: Fix for setting the thermal zone mode to
 enable/disable
Message-ID: <20120321161851.2f072204@endymion.delvare>
In-Reply-To: <CACLa4pts46gZmx=cGWF9UuHh-VpeoG9e2MmJR=xTn7sFxiFyjw@mail.gmail.com>
References: <1332328201-21191-1-git-send-email-amit.kachhap@linaro.org>
	<20120321151357.53fb86e4@endymion.delvare>
	<CACLa4pts46gZmx=cGWF9UuHh-VpeoG9e2MmJR=xTn7sFxiFyjw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, 21 Mar 2012 10:47:52 -0400, Eric Paris wrote:
> On Wed, Mar 21, 2012 at 10:13 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > Note that a quick grep suggests that drivers/misc/ad525x_dpot.c,
> > security/selinux/hooks.c and arch/m68k/sun3/prom/console.c suffer from
> > the same issue, if you want to fix them too.
> 
> I do see that we use sizeof() for strings in the selinux code, but I
> don't see a place that it is a bug.  If you see a bug let me know and
> I'd be happy to fix it!

My suspect is in sb_finish_set_opts():

	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)

If sb->s_type->name is exactly "sysfs", it will work, but if it only
starts with "sysfs" it won't. And if only exact matches are expected,
then strncmp is overkill and strcmp should be used instead.

Note that I don't know anything about the code so I might as well be
totally wrong.

-- 
Jean Delvare
