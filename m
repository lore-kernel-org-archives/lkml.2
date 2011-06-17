Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab1FQOkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:40:46 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44296 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757848Ab1FQOkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fV3SQ9BJRSIVkV1Ult0Gq3xPKKmU11GVzqZJVMB3xDGC+bEY+y8baEPcwiUc8K52bF
         nQ+g0+JfvGA0xGcoCuNMVO+lTvM/OTkcqikse0Mi/rOrF7z+oh6U7VjTFf0rWNGNJQ5t
         68uJalWybXyXdNlKyAGaeuU78ELP3r6AlLZso=
MIME-Version: 1.0
In-Reply-To: <1308320844.2586.14.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave> <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
 <1308264321.2436.161.camel@mulgrave> <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
 <1308320844.2586.14.camel@mulgrave>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 17 Jun 2011 16:40:25 +0200
Message-ID: <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de,
        yrl.pp-manager.tt@hitachi.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 16:27, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-06-17 at 01:04 +0200, Kay Sievers wrote:
>> >> We need many names, and we need all of them from the very
>> beginning,
>> >> and they should not change during device lifetime unless the device
>> >> state changes.
>> >
>> > So that's actually an argument for leaving the links, surely?  We
>> can
>> > have many inbound links, but the kernel can only print one name in
>> > messages, which would be the preferred name that was currently set.
>>
>> I really question any concept of _the_ name. My take on it: It will
>> never work in reality.
>
> OK, so lets take the common example: a desktop with three disks and an
> enclosure with three slots and labels "fred", "jim", and "betty".
>
> The desired outcome is that whenever the user manipulates those devices
> he uses a name related to the label, so whenever dmesg flags a problem,
> it says sd betty:  device offline or something.  Whenever he mounts, he
> mounts by /dev/disk/by-preferred/betty (or whatever the current udev
> vernacular is).  Whenever smartmon says there's an over temp problem. it
> says that fred has it;  cat /proc/partitions shows how fred, jim and
> betty are partitioned and so on.
>
> To do this, we set the preferred name at start of day via a machine
> specific customisation.  For an enclosure, there's a standard way of
> mapping the name to the device, so we'd just use that, but it's not
> impossible to imagine systems with stranger entities that require per
> motherboard customisations.
>
> Once the name is set in boot up, we, in fact, never alter it.
>
> With the kernel patch proposed and a corresponding update to udev
> actually makes all the above happen.  There have to be tweaks to the
> startup scripts, like smartd needs a file configuration that lists the
> disk by preferred path so that the output is correct.
>
> Obviously, I chose the commands above so there is no need to modify any
> of them.  There will be utilities (like overly smart san managers) that
> do derive the name and will need updating, but they're not among the
> standard workstation admin tools.

Ok, the still remaining questions:

Why isn't logging all symlink names during device discovery solving
all the problems we discuss without any change to the kernel? It's
just a single udev rule that can be added to ages old systems today. I
think that solves exactly the same problem and works with many names
at the same time.

Where is "fred", "jim", and "betty" stored on bootup?

What are the keys to match the pretty names to the disks?

The pretty name is a one-shot setting only? If not how is a change
handled for already used devices?

How will this information be available in the initramfs, where
mutltiple disks might need to be mounted already? Initramfs images are
generic and not created per host.

How are multipath setups handled where the exact same disk is behind
multiple kernel devices? What to put into these names in this case?

Kay
