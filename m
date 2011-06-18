Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab1FRJdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 05:33:11 -0400
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:39012 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914Ab1FRJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 05:33:08 -0400
X-Greylist: delayed 2471 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jun 2011 05:33:08 EDT
Message-ID: <c6813b0914dd61da40fc2db868ea5b11.squirrel@ssl-webmail-vh.clara.net>
In-Reply-To: <1308359856.2166.23.camel@t41.thuisdomein>
References: <bug-37682-10286@https.bugzilla.kernel.org/>
    <20110617143104.3b883bda.akpm@linux-foundation.org>
    <1308359856.2166.23.camel@t41.thuisdomein>
Date: Sat, 18 Jun 2011 09:51:17 +0100
Subject: Re: [Bug 37682] New: Kernel mis-detects size/position of partition
 created with Seagate DiscWizard (OnTrack Disk Manager)
From: markk@clara.co.uk
To: "Paul Bolle" <pebolle@tiscali.nl>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Squirrel-AuthUser: markk@clara.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Paul Bolle wrote:
> On Sat, 2011-06-18 at 03:01 +0200, Paul Bolle wrote:
>> nor could I find the commit(s) that removed it.
>
> That was 232595eaff951e96cabe5e85fed35f66b72ff51e ("ide: remove
> obsoleted "hdx=" kernel parameters"), which was applied in the v2.6.27
> cycle.

Was the feature which that commit removed specific to ide devices? That
is, would it have not applied for a drive connected via a USB/Firewire
bridge?

Ideally the kernel partition-scanning code would be fixed to handle these
strange partitions. As a temporary measure, it might be best to print a
warning and not create the incorrect block device.

E.g. user might think "I'll back up this partition"
  dd if=/dev/sdc1 of=partition.bin
or "I'll wipe this partition before disposing of the disk"
  dd if=/dev/zero of=/dev/sdc1.
Neither has the desired effect.


Mark


