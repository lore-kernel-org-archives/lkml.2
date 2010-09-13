Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0IMPsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:48:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab0IMPsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:48:03 -0400
Date: Mon, 13 Sep 2010 11:47:50 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913154750.GA26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
 <1284087065-32722-5-git-send-email-ying.huang@intel.com>
 <20100910160211.GH4879@redhat.com>
 <20100910181929.4f35ab7c@basil.nowhere.org>
 <20100910184039.GK4879@redhat.com>
 <1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
 <20100913141140.GB27371@redhat.com>
 <20100913172438.37443bf7@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913172438.37443bf7@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 05:24:38PM +0200, Andi Kleen wrote:
> 
> Don,
> 
> > Unfortunately, most of the bugzillas I deal with, unkown NMIs are the
> > result of SERRs.  While you can consider that hardware error
> > reporting, the easiest way for me to debug those problems currently
> > is to have reporters run 'lspci -vvv' after the NMI is displayed to
> > figure out who caused the NMI.
> > 
> > My fear is that panic'ing the box on unknown NMIs on those platforms
> > will hinder my ability to easily debug those NMIs.
> 
> 
> The reason the NMI is sent is that there is a "lost" 
> data corruption somewhere in the system and if you don't 
> stop it the system the corruption may make it to disk,
> become permanent etc. The hardware was designed
> under the assumption that  the system is stopped by software
> when this happens (same reason as why many machine
> checks cause panics)

Yeah, I know. I was being too ignorant perhaps.

> 
> Then there isn't necessarily something to "debug": data corruption
> can happen without any bugs being around (and in fact
> that's the common case, assuming production systems)
> 
> So I'm not sure what you're debugging here. Are you being the support
> technician for the system through bugzilla? That sounds
> inefficient.

The problem I repeatedly deal with for RHEL systems is a customer sees an
unknown NMI printed on their screen and sometimes the machine falls apart
shortly after, sometimes it doesn't.  Obviously they are going to file a
bug asking why.  A chunk of the problems are bad hardware/firmware.  But
the problem is which one.

Replacing a slot card is easy, replacing a motherboard is not.  So I
usually try to determine which device is failing by walking the pci bus
and looking for the serr bits or some of the pci-e status bits.

It is inefficient, but I haven't had time to figure out a way to clean it
up.  And just for the record, I usually see an unknown NMI report every
other week.

> 
> Anyways for hardware support we could probably dump some
> more information at panic or better through error
> serialization, but the word "debug" is IMHO an very wrong
> way to think about that.

Well, I can use 'diagnos' or 'determine' if you want.  But at the end of
the day, we have customers that see scary software messages and expect us
to give them reasonable direction to fix their problems.

> 
> If this is about driver debugging it's entirely reasonable
> to have a special setting (e.g. disable the panic), 
> but the defaults should be set in a way to avoid
> spreading data corruption,.

Ok.  I can accept that.

Cheers,
Don
