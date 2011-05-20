Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934962Ab1ETBV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:21:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43272 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379Ab1ETBVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:21:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=BGCnmpuy9JpHwQUPP+yO1U6Zqpx1vfl6mh1i/zTVcSlF9aCmH8T+FL8toK2SSWTsw+
         R4xgTU7JdbUv7arsemBlITQsTY/M2MichCBtSHsXKaV2NTcWAvTDYK+XWIsrQBpapcRB
         ZGfcG6A/dyG+iKUcfq4trSvQLzjiKSM7zbSp0=
MIME-Version: 1.0
In-Reply-To: <1305851941.7481.92.camel@pasglop>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	<1305753895-24845-6-git-send-email-ericvh@gmail.com>
	<1305851941.7481.92.camel@pasglop>
Date: Thu, 19 May 2011 20:21:54 -0500
Message-ID: <BANLkTinAqeu7C+U_HFrOAOctFTuSUwG-iA@mail.gmail.com>
Subject: Re: [PATCH 6/7] [RFC] enable early TLBs for BG/P
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 7:39 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
>> BG/P maps firmware with an early TLB
>
> That's a bit gross. How often do you call that firmware in practice ?
> Aren't you better off instead inserting a TLB entry for it when you call
> it instead ? A simple tlbsx. + tlbwe sequence would do. That would free
> up a TLB entry for normal use.
>

Well, it depends on who you talk to.  The production software BG/P
guys use the firmware
constantly, its the primary interface to the networks, the console,
and the management software
which runs the machine.  As such the IO Node guys, the Compute Node
Kernel guys and the
ZeptoOS guys use it quite a bit.  The kittyhawk guys on the other hand
barely use it at all, in fact
I believe they do all the interaction with it during uboot and then shut it off.

IIRC, the sticky question is RAS support, there are certain things it
wants to jump to firmware
to deal with and expects things to be mapped an pinned into memory.
Furthermore, I think it
may make assumptions about where in the TLB the mappings are.  Since
the kittyhawk guys
obviously ignore this by shutting it down, its not clear just how
important this is.  I'm game to
try the dynamic mapping as you suggest if you would prefer it.

Its worth mentioning that I believe with BG/Q, the plan is to rely on
the firmware even more
extensively, but I haven't looked at any of the code yet to verify
whether or not this is true.

     -eric
