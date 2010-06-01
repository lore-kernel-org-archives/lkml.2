Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab0FAFgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:36:49 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48981 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab0FAFgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:36:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HsYxDw3f0QfftW82QMkcakt3/7IvohYBz40WPXcsdTSdBzuKoRgO1JElV/KAJ1hTdK
         3GRuuTzPd5jnYq2EH2rw3Fc3FSRLUFaTj0kBRYt9x7FEidZxKM6wwoBZoZygspbuUXRB
         G7X2OeKruR7wqb8IlJGxGwGfBnhrljI/CD7qo=
Message-ID: <4C049C6A.8060605@garzik.org>
Date: Tue, 01 Jun 2010 01:36:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Chris Mason <chris.mason@oracle.com>
Subject: Re: SSD + sata_nv + btrfs oops
References: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
In-Reply-To: <AANLkTilqsIdlzZgUf7TMLHYKqHDZoVkcs42vcG8wXKEr@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 11:04 PM, Dave Airlie wrote:
> Hi guys,
>
> I've been running an Intel SSD (the KS one) on my Dell XPS710 desktop
> machine, with btrfs on it.
>
> I'm not sure the btrfs oops isn't due to the disk/controller doing
> something bad (almost guaranteed).

The btrfs oops may be poor handling of an I/O error thrown by the block 
error.

Root cause is definitely your SATA PHY throwing some hardware errors 
from the transport layer (low level SATA packet transmission failures). 
  Everything else sorta falls apart after that.

First guesses are the usual suspects: cabling, temperature, power or 
SATA ports on the [SATA controller | SATA device] going bad.

Disabling swncq will only improve things from the perspective of slowing 
things down and giving the hardware less to do.  swncq makes things 
parallel, so forcing only one transaction at a time certainly increases 
the chances of success by reducing complexity and serializing transactions.

	Jeff



