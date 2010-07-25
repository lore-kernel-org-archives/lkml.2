Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab0GYVAy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 17:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0GYVAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 17:00:53 -0400
Message-ID: <4C4CA601.6020201@redhat.com>
Date: Sun, 25 Jul 2010 23:00:49 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.7) Gecko/20100713 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Nils Radtke <lkml@Think-Future.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: cryptsetup + lvm on usb disk, unusable /dev/dm-* after suspend/resume
 cycle
References: <20100725160641.GK31966@localhost>
In-Reply-To: <20100725160641.GK31966@localhost>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2010 06:06 PM, Nils Radtke wrote:

>   Using an external usb 2 hdd with recent kernels with cryptsetup containers that
>   contain lvm volumes. 
> 
>   After a suspend/resume cycle, with active lvm volumes, the mounted fs is "offline", 
>   the dm-* devices don't respond to commands issued. No more access possible.
>   
>   Have to reboot to free the devices.

I guess it is not dm/block layer problem but USB related - can you check syslog if
the device is not attached after resume with another major:minor?

If this happens - you can free the mappings using dmsetup:
- try to force umount fs (if mounted), then run "dmsetup table" and manually remove
orphaned mappings using "dmsetup remove".

Milan
