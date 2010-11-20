Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab0KTQby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 11:31:54 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46701 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0KTQbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 11:31:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type;
        b=d5YD3V3ssCbLpNsEhqtePUkM5yFkUyVdiLPAzpFb0N32qeHkqV3gji3WSQL1it/qyK
         A7vL9VhOLV/5ULv6HMUz/ZC1P2JngY14Qp927qRJaZ3qfGLr9twae0qo3M99HFJAj1K3
         pqNn8v1N4uLWsAwV/AMcu3ivavY1+HWpNJkak=
From: Ben Gamari <bgamari@gmail.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch] x86: avoid unnecessary smp alternatives switch during suspend/resume
In-Reply-To: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Notmuch/0.5-3-g22aadfc (http://notmuchmail.org) Emacs/23.1.1 (x86_64-pc-linux-gnu)
Date: Sat, 20 Nov 2010 11:31:46 -0500
Message-ID: <87tyjcj6rx.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 16:09:24 -0800, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> During suspend, we disable all the non boot cpus. And during resume we bring
> them all back again. So no need to do alternatives_smp_switch() in between.
> 
> This speeds up both suspend and resume paths.
> 
Do you have typical before/after values? Is the change on the order of
microseconds, hundreds of milliseconds, or somewhere in between? It
might be good to note this in the changelog.

- Ben
