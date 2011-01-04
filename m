Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1ADUj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:39:56 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:40147
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005Ab1ADUjz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:39:55 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110104.121958.232738534.davem@davemloft.net>
References: <1294156627.17576.21.camel@lithium>
	 <20110104.092637.226761806.davem@davemloft.net>
	 <1294171877.17576.24.camel@lithium>
	 <20110104.121958.232738534.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Tue, 04 Jan 2011 20:38:22 +0000
Message-ID: <1294173502.17576.26.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d238598.25b9-7647-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 12:19 -0800, David Miller wrote:

> First of all, the machine dies because those illegal I/O accesses
> generate an unrecoverable asynchronous memory error, we cannot recover
> from it so we have to panic the entire machine.
> 
> Secondly, the keyboard doesn't work because I never implemented the
> monstrous amount of code necessary to allow USB keyboard to work with
> OpenPROM after booting up.
> 
> You have to essentially reset the entire USB host controller, unload
> all of the pending queued URBs in the host controller, put it into a
> quiescent state, and then asynchronously process all USB keyboard
> device events via USB host controller polling implemented via OpenPROM
> backcalls into the kernel, and from there feed the characters to
> OpenPROM so it can see the keypresses.  Upon return from OpenPROM you
> have to reload all of the unloaded URBs back onto the USB host
> controller queues so the kernel can use USB again.
> 
> I never considered this enormous amount of work worth doing, the
> payback is just too small.

Thank you for that explanation, it's much appreciated.
-- 
Tactical Nuclear Kittens
