Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab0ICPcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 11:32:17 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54033 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab0ICPcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 11:32:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=lNBJQ+dyWJAvkYI21qNMsE43DzI3LTwu49tMqmoUuk0UNZwp5BIBYlADrWX70HE8sr
         AIulu6uXh4kUMS4QSMPt3C/B6Qcl6suXQQod/OsFqwmVpD+HvurPRypuIFDcZgdTy4SS
         GXcoUmh0XCIsgwEXrfzxmRJuCjCGuoHSdDhvE=
Date: Fri, 3 Sep 2010 18:32:38 +0300
From: Jarkko Nikula <jhnikula@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Fix machine constraints apply for min_uV !=
 max_uV
Message-Id: <20100903183238.23f9887c.jhnikula@gmail.com>
In-Reply-To: <20100903145420.GB7614@rakim.wolfsonmicro.main>
References: <1283521429-32499-1-git-send-email-jhnikula@gmail.com>
	<20100903145420.GB7614@rakim.wolfsonmicro.main>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 15:54:20 +0100
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> This is deliberate behaviour, apply_uV can only be used with a fixed
> voltage at startup in order to avoid issues with handover from the
> bootloader if we suddenly drop the supply voltage on a device which has
> not yet been claimed by a driver.  The expectation is that if the
> voltage can vary then something that understands the hardware state
> needs to be involved in maintaining the voltage.

Ah, true. It could be possible that machine constraints are specified
broader, like they include standby state voltage which is not enough to
probe & initialize the device etc.


-- 
Jarkko
