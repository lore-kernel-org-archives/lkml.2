Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab1ETNBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:01:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54199 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab1ETNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IR2Ysr9r0K0SFVXngP+N/myY3StsOxDLf6pya+ylv1ttXtnBAHg8W3P9X7kCbLtdtM
         1ndfEco3xi1rulDf1vvWCWo0t5/+vZLKuwx0lhvNK3zi0JyOpTRi6Ma++c5x6jgreCLL
         mStI/GWCE7QDUwpgxtH49M6ljIEvby7ZiMSKg=
MIME-Version: 1.0
In-Reply-To: <1305863541.7481.132.camel@pasglop>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<1305753895-24845-6-git-send-email-ericvh@gmail.com>
	<1305851941.7481.92.camel@pasglop>
	<BANLkTinAqeu7C+U_HFrOAOctFTuSUwG-iA@mail.gmail.com>
	<1305856442.7481.120.camel@pasglop>
	<4DD5E218.5030508@mcs.anl.gov>
	<1305863541.7481.132.camel@pasglop>
Date: Fri, 20 May 2011 08:01:47 -0500
Message-ID: <BANLkTikG9mfzXM0WmWxPLhjGD-M6AVznkw@mail.gmail.com>
Subject: Re: [bg-linux] [PATCH 6/7] [RFC] enable early TLBs for BG/P
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kazutomo Yoshii <kazutomo@mcs.anl.gov>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 10:52 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>> Unfortunately, the firmware is also required:
>> - to configure Blue Gene Interrupt Controller(BIC)
>> - to configure Torus DMA unit. e.g. fifo
>> - to configure global interrupt (even we don't use, we need to disable
>> some channel correctly)
>
> Can't we just write bare metal code for that ?
>

The kittyhawk code has the bare-metal equivalents for all of these.
When I get to the drivers, I'll favor the kittyhawk versions for
submission and then we'll see if it would be possible to adapt the HPC
extensions to use the bare-metal versions of the drivers versus the
firmware interface.

>> - to access node personality information (node id, DDR size, HZ, etc) or
>> maybe we can directly access SRAM?
>
> That should be turned into device-tree at boot, possibly from a
> bootloader or from the zImage wrapper.
>

This is the approach is used by the kittyhawk u-boot approach.
However, it would also be just as easy to construct an in-memory
device-tree within Linux by mapping the personality page and copying
the relevant bits out.  This has the advantage of being able to boot
Linux directly on the nodes without an intermediary boot loader (which
kittyhawk uses just to allow us customize which kernel boots on a
node-to-node basis whereas the stock system boots the same kernel on
all the nodes within a partition allocation (64-40,000 nodes)).

         -eric
