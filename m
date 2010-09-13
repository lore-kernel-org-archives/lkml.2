Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0IMPYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:24:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34286 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0IMPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:24:44 -0400
Date: Mon, 13 Sep 2010 17:24:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100913172438.37443bf7@basil.nowhere.org>
In-Reply-To: <20100913141140.GB27371@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<1284087065-32722-5-git-send-email-ying.huang@intel.com>
	<20100910160211.GH4879@redhat.com>
	<20100910181929.4f35ab7c@basil.nowhere.org>
	<20100910184039.GK4879@redhat.com>
	<1284344389.3269.82.camel@yhuang-dev.sh.intel.com>
	<20100913141140.GB27371@redhat.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don,

> Unfortunately, most of the bugzillas I deal with, unkown NMIs are the
> result of SERRs.  While you can consider that hardware error
> reporting, the easiest way for me to debug those problems currently
> is to have reporters run 'lspci -vvv' after the NMI is displayed to
> figure out who caused the NMI.
> 
> My fear is that panic'ing the box on unknown NMIs on those platforms
> will hinder my ability to easily debug those NMIs.


The reason the NMI is sent is that there is a "lost" 
data corruption somewhere in the system and if you don't 
stop it the system the corruption may make it to disk,
become permanent etc. The hardware was designed
under the assumption that  the system is stopped by software
when this happens (same reason as why many machine
checks cause panics)

Then there isn't necessarily something to "debug": data corruption
can happen without any bugs being around (and in fact
that's the common case, assuming production systems)

So I'm not sure what you're debugging here. Are you being the support
technician for the system through bugzilla? That sounds
inefficient.

Anyways for hardware support we could probably dump some
more information at panic or better through error
serialization, but the word "debug" is IMHO an very wrong
way to think about that.

If this is about driver debugging it's entirely reasonable
to have a special setting (e.g. disable the panic), 
but the defaults should be set in a way to avoid
spreading data corruption,.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
