Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab0JHMDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 08:03:42 -0400
Received: from atl.turmel.org ([74.117.157.138]:44307 "EHLO atl.turmel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab0JHMDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 08:03:40 -0400
Message-ID: <4CAF089B.40204@turmel.org>
Date: Fri, 08 Oct 2010 08:03:39 -0400
From: Phil Turmel <philip@turmel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20101003 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Strange raid device numbering
References: <20101008014318.04d7ded1@werewolf.home>
In-Reply-To: <20101008014318.04d7ded1@werewolf.home>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi J.A.,

On 10/07/2010 07:43 PM, J.A. Magallón wrote:
> Hi...
> 
> I'm running kernel 2.6.36-rc6.
> I have just built a simple raid0 array with two disks, and I followed what I
> had always done:

[snip /]

> Strangely, after I reboot, the system insists in numbering it as
> md127, instead of md0.
> 
> Why ?
> How can I force it to be md0 ? (its half aesthetics, half curiosity...)

I'm gonna guess that you have some combination of an initramfs, and/or you
don't have an /etc/mdadm.conf, and/or you haven't updated your initramfs with
the latest copy of it.

Raid auto-assembly in the kernel uses the minor numbers in the superblock (if
it can).  Assembly by mdadm without instructions from mdadm.conf uses minor
numbers from 127 and down.  (This may have changed in mdadm in the last few
months, but I recently switched from kernel auto-assembly to initramfs
assembly, so I can't say for sure.)

I've chosen to *not* use mdadm.conf, and find all of my devices with "LABEL="
syntax.

HTH,

Phil
