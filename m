Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1FQPjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:39:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33765 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab1FQPjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:39:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=vrfy.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RAe/g5bgoT4fW3EDmKd7xYNgUqNGstVoR0UuadFhExWVD+gGp/zT2T9t1QMbq1q8zC
         hX8Wf6LISja3+jaRtszJnEdKD7DQkFOCvOzqQJYbraitUNxuWihNWBoMmPEXd8gasHp9
         sz6Cul3Jpu3CCUXu1W5iITmH5Hpl0oNm3ZhXE=
MIME-Version: 1.0
In-Reply-To: <1308322193.2586.30.camel@mulgrave>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave> <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
 <1308264321.2436.161.camel@mulgrave> <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
 <1308320844.2586.14.camel@mulgrave> <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com>
 <1308322193.2586.30.camel@mulgrave>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 17 Jun 2011 17:39:23 +0200
Message-ID: <BANLkTinywFK3yAxN51O7RDYyqeNRHBRThA@mail.gmail.com>
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

On Fri, Jun 17, 2011 at 16:49, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-06-17 at 16:40 +0200, Kay Sievers wrote:

>> Ok, the still remaining questions:
>>
>> Why isn't logging all symlink names during device discovery solving
>> all the problems we discuss without any change to the kernel? It's
>> just a single udev rule that can be added to ages old systems today. I
>> think that solves exactly the same problem and works with many names
>> at the same time.
>
> It could ... but that doesn't solve the prink problem or
> the /proc/partitions one.  The idea is to allow naive users to identify
> their device physically when the system logs something about it.  Having
> to describe a manual mapping procedure is very complex for them.

How? You see 'sda kaput' then you scroll up to the last udev message
with /dev/disk/by-all-the-many-names/. Anyone who can't do this should
not even get access to the log file. :)

>> Where is "fred", "jim", and "betty" stored on bootup?
>
> So this is subsystem specific.  For the case of a SCSI enclosure, I can
> answer that it's actually burned into the enclosure firmware.  When you
> build an enclosure with labels, the label names are stored in a
> diagnostic page.  We can actually interrogate the enclosure directly or
> use the ses driver to get these names mapped to current devices.

To me this sounds like a nice name on top of the current bunch of
names, not like a 'preferred' name.

I still don't like to introduce any new facility to the kernel that
can handle only one single name. Reality the last years has taught us
a very different story, and we've walked a long way to get where we
are. I really don't believe single names will ever work, it's just a
nice theory.

>> What are the keys to match the pretty names to the disks?
>>
>> The pretty name is a one-shot setting only? If not how is a change
>> handled for already used devices?
>
> obviously, one device will be root, and it will already be used
> as /dev/root, but the proposal isn't to change any name, it's merely to
> set "fred" as the preferred name for /dev/root, which is also /dev/sdc
> and /dev/disk/by-id/naa-566dce3ddf etc ...

Sure, sounds nice. I just don't see how all that can be done
automatically in a sane way. It's like telling people to name their
network interfaces "internal", "external", "dmz". Almost nobody is
doing this, there is even the netif alias support already, and nobody
wants to use it besides a few SNMP tools. In my experience, stuff
needs to work out-of-the-box, or it is not used.

>> How will this information be available in the initramfs, where
>> mutltiple disks might need to be mounted already? Initramfs images are
>> generic and not created per host.
>
> That's initramfs specific.  However, if, in deference to your new
> location, we look at dracut, it has a modules directory for plugin
> extensions.  The scripts which do the mapping can be inserted there as
> an additional rpm.

That's not really what I meant. I want to hear how the decision is
made which one of the multiple possibilities for the name composition
is chosen. Ideally it needs to work in a generic setup, not with a
customized host-specific file included even in the initramfs image.

>> How are multipath setups handled where the exact same disk is behind
>> multiple kernel devices? What to put into these names in this case?
>
> I'm not sure I understand the question.  a md setup of RAID-1 on fred
> and betty would assemble using /dev/disk/by-preferred/fred
> and /dev/disk/by-preferred/betty.  Whether the user want's to
> call /dev/md0 something pretty is up to them ... it's not a physically
> labelled entity, so I'd tend just to leave it with its default name as
> the preferred name.

I mean multi-path not raid. Disks have all the same ids, same
locations, but we have multiple kernel devices for them.

Kay
