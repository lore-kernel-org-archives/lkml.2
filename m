Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0F3WO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:14:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46613 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755927Ab0F3WO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:14:28 -0400
Message-ID: <4C2BC1AB.9050500@zytor.com>
Date: Wed, 30 Jun 2010 15:14:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jan Beulich <JBeulich@novell.com>, "mingo@elte.hu" <mingo@elte.hu>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Ky Srinivasan <KSrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -	 Xen
  implementation
References: <4C2A200F02000078000089E4@vpn.id2.novell.com> <4C2B1769.5090107@goop.org> <4C2B47190200007800008CB7@vpn.id2.novell.com> <4C2B4564.7030203@goop.org>
In-Reply-To: <4C2B4564.7030203@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 06:23 AM, Jeremy Fitzhardinge wrote:
> 
> pvops is a superset of alternative instruction patching, and are really
> designed to serve different purposes.  There are some areas in which
> there's some overlap, but otherwise they are distinct.  In particular,
> alternative instructions are really only useful if you can express the
> patch in terms of the presence or absence of a particular cpu feature. 
> It can't do multi-way choice, and it can't do anything other than insert
> literal instructions.  pvops patching can do multi-way, and has a
> higher-level view of each patch site which allows it to do things like
> generate appropraite save/restores, make inline vs call decisions, nop
> out nop callsites, etc.
> 

A lot of this -- in particular the multiway -- is a defect in the
alternatives implementation and should have been addressed as such.  One
of the biggest problems with pvops as it currently stands is that it is
monolithic; in general we have this class of problems (static selection)
in a *lot* more places than we're dealing with right now, and as such,
generalizing *something* -- be it pvops or alternatives -- would be useful.

gcc 4.5 also includes a very powerful facility called "asm goto", which
I have already used to implement static_cpu_has().  Again, that
particular construct (unlike "asm goto" itself) doesn't support multiway.

	-hpa

