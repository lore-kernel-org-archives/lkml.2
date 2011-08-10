Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab1HJIdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:33:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:35877 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1HJIdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:33:31 -0400
Message-ID: <4E424255.5060405@linutronix.de>
Date: Wed, 10 Aug 2011 10:33:25 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Chris Wright <chrisw@redhat.com>, "Hans J. Koch" <hjk@hansjkoch.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Anthony Foiani <anthony.foiani@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uio/gen-pci: don't enable interrupts in ISR
References: <20110804204606.GA19724@linutronix.de> <20110804210413.GA29222@redhat.com> <20110805191842.GA4224@linutronix.de> <20110808064050.GC5182@redhat.com> <4E411D72.7000604@linutronix.de> <20110809120206.GB524@redhat.com>
In-Reply-To: <20110809120206.GB524@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> Let's assume we start with e.g. io enable bit cleared.
> 
> 
>     user                                kernel
>  read config                               |
>  set io enable                             |
>      |                                  interrupt                                                
>      |                              read + set interrupt mask
>  write config back                         |
> 					write
> 
> 
> 
> We end up with io enable bit cleared. Locking around rmw
> that we have fixes this race.

Okay, forgot about the SMP case, sorry.

Sebastian
