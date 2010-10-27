Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab0J0WFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:05:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:56425 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab0J0WFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:05:37 -0400
Message-ID: <50654.84.105.60.153.1288217125.squirrel@gate.crashing.org>
In-Reply-To: <20101027210457.23673.qmail@kosh.dhis.org>
References: <20101027210457.23673.qmail@kosh.dhis.org>
Date: Thu, 28 Oct 2010 00:05:25 +0200 (CEST)
Subject: Re: Pegasos OHCI bug (was Re: PROBLEM: memory corrupting bug,
From: "Segher Boessenkool" <segher@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: "Olaf Hering" <olaf@aepfle.de>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > |1. How do I locate all usb nodes in the device tree?
>> > |
>> > |2. How do I know if a particular usb node is OHCI?

You look for compatible "usb-ohci".

But this doesn't help you.  You do not know yet if the
problem happens for all usb-ohci; for example, it could be
that you have the console output device on usb; or as another
example, it could be that this firmware leaves all pci devices
in some active state.

So as I see it you have only two options:

1) Figure out what exactly is going on;
or 2) make the kernel shut down all pci devices early (either
in actual kernel code, or in an OF boot script).

> The big question that I'm still stumbling over is how to access the device
> registers. The "reg" property looks like this:

You should look at "assigned-addresses", not "reg".  Well,
you first need to look at "reg" to figure out what entry
in "assigned-addresses" to use.


Segher

