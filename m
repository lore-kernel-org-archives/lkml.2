Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992506Ab2JYRl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:41:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36153 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab2JYRl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:41:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121025172542.GG11442@htj.dyndns.org>
References: <1351184161-31433-1-git-send-email-computersforpeace@gmail.com>
	<1351184161-31433-4-git-send-email-computersforpeace@gmail.com>
	<20121025172542.GG11442@htj.dyndns.org>
Date: Thu, 25 Oct 2012 10:41:57 -0700
Message-ID: <CAN8TOE_DThBeGvHN9HQtX3CDLuiWDJEVZNKFqRnnOmP=xHN8XQ@mail.gmail.com>
Subject: Re: [RFC 3/3] libata: don't perform HW activity in devres
From: Brian Norris <computersforpeace@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 10:25 AM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Oct 25, 2012 at 09:56:01AM -0700, Brian Norris wrote:
>> devres functions are intended for simplified cleanup of memory and other
>> software resources on device exit, not for hardware shutdown sequences.
>> In addition, inducing hardware activity at device removal hamstrings
>> some drivers (particularly ahci_platform) so that they cannot totally
>> power off their hardware before removal, as devres cleanup occurs after
>> the driver's exit() sequence.
>>
>> More concretely, I experience the following bus error when using rmmod
>> to remove (and power off) the SATA block on my SoC:
>
> Shouldn't poweroff happen from ->port/host_stop()?

Hmm, I guess that makes more sense. I was using the ahci_platform
ahci_platform_data->exit() function. Would it be safe to call the
platform init()/exit() functions as part of a
ata_port_operations.host_{start,stop}() hook? These functions aren't
currently implemented at all in ahci_platform, but I don't see why
they couldn't be.

Brian
