Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0DWXB1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:01:27 -0400
Received: from solo.fdn.fr ([80.67.169.19]:49759 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab0DWXBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:01:25 -0400
Date: Sat, 24 Apr 2010 01:01:21 +0200
From: Samuel Thibault <samuel.thibault@inria.fr>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org, olivier.aumage@inria.fr,
       yannick.martin@inria.fr
Subject: Re: X86_64 BUG: missing FS/GS LDT reload on fork()
Message-ID: <20100423230121.GA4563@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@inria.fr>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
	olivier.aumage@inria.fr, yannick.martin@inria.fr
References: <20100423170449.GV4997@const.bordeaux.inria.fr> <4BD1E061.8030605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BD1E061.8030605@zytor.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

H. Peter Anvin, le Fri 23 Apr 2010 11:01:05 -0700, a écrit :
> On 04/23/2010 10:04 AM, Samuel Thibault wrote:
> > I have an issue with FS/GS LDT reload in the child of fork(). The
> > attached testcase fails quite often.  It sets an LDT entry up, uses
> > prctl to set gs's base to a 64bit value, then loads gs with the LDT
> > entry. The LDT entry is now in effect. After a fork call, the LDT entry
> > is not in effect any more, the 64bit base is back!
> 
> Okay... I have to say that I'm more than a bit confused why you're doing
> this,

:D

I'm fixing a user-level thread library with TLS support.

> The following patch looks like it should address that.

Indeed, it fixes the issue here.

Samuel
