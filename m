Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab0GGXP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 19:15:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59652 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab0GGXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 19:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WRHfY5RrY7DO4riL4Y6PeiBHpp0QJAK2xksCLr99FSuhaPvXBeTQbUVI3+uoZmzoo9
         lqMbZz3aym0C1aBeQZKihWuJg2saLsv+KQvlsBJZ6u9CWb7cIVLn59MLfyogCefBgiHA
         NsrUkrmgU05vL9ruakVAcSskwokDWr7kfGd3M=
MIME-Version: 1.0
In-Reply-To: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
Date: Wed, 7 Jul 2010 16:15:55 -0700
Message-ID: <AANLkTikaM7O-pCW2CaHDRKzycVoWvzpM-9zA9creAtcV@mail.gmail.com>
Subject: Re: nic enumeration
From: Steve Fink <sphink@gmail.com>
To: Michael Di Domenico <mdidomenico4@gmail.com>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 7, 2010 at 3:25 PM, Michael Di Domenico
<mdidomenico4@gmail.com> wrote:
> What I'm curious about is how/why Linux actually decides Nic1 should be Eth0?
>
> My theory is it starts on the lowest MAC address and works up,
> depending partly on driver load order.

I may be spewing misinformation here, but my understanding of how this
works is that the specific ordering is pretty much random. It's rather
unlikely to be based on MAC address value, except accidentally; it's
probably just whatever comes up first when it enumerates the
interfaces, which could easily be timing-dependent. (From personal
experience, two identical but physically separate NICs will come up in
a different order on every boot. Your case may be more consistent.)

The first time it does this, though, it records the MAC address into
the appropriate ifcfg-* script. From then on, at boot time it checks
the MAC address of each interface as it comes up. If it mismatches
with what is recorded in the ifcfg-* script, then it skips that name
and tries using the next.

In other words, all you should have to do is set HWADDR appropriately
in the the ifcfg-* scripts and it should do the right thing.
