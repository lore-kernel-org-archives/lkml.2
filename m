Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab0GXIBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 04:01:53 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45601 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab0GXIBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 04:01:52 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C4A9DD8.9080200@s5r6.in-berlin.de>
Date: Sat, 24 Jul 2010 10:01:28 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
CC: Jay Fenlason <fenlason@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.35-rc6 to 2.6.32.16: JuJu firewire issues
References: <4C49A291.20001@ribosome.natur.cuni.cz> <20100723180807.GA32319@redhat.com> <4C49E1A2.7050606@ribosome.natur.cuni.cz> <4C4A074D.4050305@s5r6.in-berlin.de>
In-Reply-To: <4C4A074D.4050305@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Martin Mokrejs wrote at LKML:
>> Hi Jay,
>> Jay Fenlason wrote:
>>> On Fri, Jul 23, 2010 at 04:09:21PM +0200, Martin Mokrejs wrote:
>>>> Hi,
>>>>   I bought a external harddrive with firewire and USB interfaces (IcyBOX IB-250StUE-B).
>>>> If I connect it to a desktop computer A I get kernel crash during boot (see
>>>> both attached dmesg-*.txt files).
> 
> The crash which you reported is in sbp2 (of the old ieee1394 stack alias
> linux1394, not in firewire-sbp2 (of the new firewire stack alias juju).

I have logged your report as
	https://bugzilla.kernel.org/show_bug.cgi?id=16452
	nodemgr, sbp2: NULL pointer dereference in sbp2_update
but set its status to WILL_NOT_FIX for now.

The bug seems to be in the nodemgr component of the ieee1394 core
driver.  This is one of the things that were rewritten from scratch in
firewire-core with a fundamentally different implementation, for good
reasons.

Perhaps somebody else wants to look into a possible fix for this bug,
but this seems very unlikely.  (Basically, a bug fix already exists in
the form of firewire-core.)
-- 
Stefan Richter
-=====-==-=- -=== ==---
http://arcgraph.de/sr/
