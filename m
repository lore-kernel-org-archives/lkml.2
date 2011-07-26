Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab1GZPEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:04:51 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33392 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751573Ab1GZPEq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:04:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=a7h0BdWN8Js1l9nWh9NOg/xwkABngL8JluPY7/fJ+hzGaSH9RZdPQyqqkKGcIFoCd/+k6IHorBN8HBnPNGvkTnZNUf31krvvEZCG4p7qStq+chmBfCEH9NpEgdZoQLs+;
Date: Tue, 26 Jul 2011 08:04:43 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Michal Marek <mmarek@suse.cz>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kbuild@vger.kernel.org, lacombar@gmail.com, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com
Subject: Re: [RFC][PATCH 1/2] kconfig: Introduce KCONFIG(),
 KCONFIG_BUILTIN() and KCONFIG_MODULE()
Message-Id: <20110726080443.62196869.rdunlap@xenotime.net>
In-Reply-To: <4E2EBF63.8050208@suse.cz>
References: <4E1D9C25.8080300@suse.cz>
	<1311634718-32588-1-git-send-email-mmarek@suse.cz>
	<CAM_iQpUEfYrrtpcRLTekSHMHrTTka6ir=z_GUUbnxuQKfY+OXA@mail.gmail.com>
	<4E2EBF63.8050208@suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jul 2011 15:21:39 +0200 Michal Marek wrote:

> On 26.7.2011 15:01, Américo Wang wrote:
> > On Tue, Jul 26, 2011 at 6:58 AM, Michal Marek<mmarek@suse.cz>  wrote:
> >> Replace the config_is_*() macros with a variant that allows for grepping
> >> for usage of CONFIG_* options in the code. Usage:
> >>
> >>   if (KCONFIG(CONFIG_NUMA))
> >>
> >> or
> >>
> >>   #if KCONFIG(CONFIG_NUMA)
> >>
> >> The KCONFIG() macro evaluates to 1 if the argument is set (to either 'y'
> >> or 'm'), KCONFIG_BUILTIN() and KCONFIG_MODULE() test if the respective
> >> option is 'y' and 'm', respectively.
> >
> > I think it's better to let KCONFIG_MODULE() returns true only for =m, so that
> > KCONFIG() will equal to KCONFIG_BUILTIN() || KCONFIG_MODULE().
> 
> This is how it's done.
> 
> 
> > BTW, the name KCONFIG(CONFIG_NUMA) seems ugly.
> 
> Suggest a better one :). The proposals so far:
> config_is_numa() (breaks grep)

explain, please.

> CONFIGURED(CONFIG_NUMA)
> ENABLED(CONFIG_NUMA)
> KCONFIG(CONFIG_NUMA)

CONFIG(NUMA) || CONFIG(NUMA_BUILTIN) || CONFIG(NUMA_MODULE)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
