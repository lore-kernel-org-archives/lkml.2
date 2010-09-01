Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab0IATvW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 15:51:22 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61965 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab0IATvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 15:51:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:user-agent:mime-version
         :content-type:content-transfer-encoding:x-priority:importance;
        b=OqAsM41Bxn1e3q1gGOnjvGlqEMOkI54b3hHHXI8Aax0e0XDQhdKskYl3wDLgNnegFz
         2GcnoFNYDcroYsiN4Xp89wOTXwdVb/dvlQ04XGX+7uDdd7a4P/BRItdGnN2YwD2xK2Lr
         nP8Ar5n93bGmXpuuNyLlfNsqmdDIJPoepPPmk=
Message-ID: <63e423a0c8ebc4c6e448622c1d0cb99f.squirrel@localhost>
Date: Wed, 1 Sep 2010 14:51:17 -0500
Subject: How to allocate a region of address space (NOT RAM!)
From: david.hagood@gmail.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working with a single chip system (specifically, a PPC core) that has
onboard devices. I need to allocate a region of address space that is
unused, so that I can configure one of the on-chip devices to occupy that
space. The region of address space allocated must NOT have anything there
already - no RAM, no devices.

As far as I can see, there is no "bus" object I can talk to in order to
allocate address space, as one would do when allocating space on PCI. How
do I grab a region of address space, and be sure that nobody else is going
to frob it?

I could just look at the memory map, plunk my flag down and say "I claim
this address in the name of Endpoint!" but that doesn't keep me from
accidentally laying claim to New York, nor does it stop somebody else from
sailing in behind me and plunking their flag down.

Is there some master resource somewhere in the kernel that tracks the
allocation of physical address space, in the same way that kalloc tracks
the allocation of RAM space? Is there some API I've missed that will
allocate space and make sure it gets mapped into virtual space for me, or
will I have to roll my own solution?


