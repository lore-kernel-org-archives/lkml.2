Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0ELVlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:41:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48487 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758093Ab0ELVlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:41:12 -0400
MIME-Version: 1.0
X-Originating-IP: [172.24.11.26]
In-Reply-To: <20100512205846.GG2377@agk-dp.fab.redhat.com>
References: <20100512203054.GA22104@z600>
	 <20100512205846.GG2377@agk-dp.fab.redhat.com>
Date: Wed, 12 May 2010 16:41:10 -0500
X-Google-Sender-Auth: Bni-3V-q_NY1GNnHAFrq19rO-5Q
Message-ID: <AANLkTikJrrq7vfr9VwRsE92wfW8smJe8WNwOJoZQygk1@mail.gmail.com>
Subject: Re: [dm-devel] [RFC PATCH] init: boot to device-mapper targets 
	without an initr*
From: Will Drewry <wad@chromium.org>
To: agk@redhat.com
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 3:58 PM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Wed, May 12, 2010 at 03:30:54PM -0500, Will Drewry wrote:
>> The format is dm=minor,rwmode,begin,length,target,target,params,with,commas
>
> 1. If we go down this route, pick a format that gives access to the full
> set of allowed table formats (or which can be extended trivially to do
> so in future).  So cope with multi-line tables e.g. with a marker (empty
> field?) to start a new table line.

Sounds good.  That shouldn't add any serious code complexity either.
An empty field (,,) would probably work nicely.

> 2. It would be wise to define a name and optional uuid too, so the device is
> fully visible and accessible from userspace through existing mechanisms.
> Originally the name+uuid were decoupled from the mapped device itself,
> but that got changed, though the code layout (dm-ioctl.c vs. dm.c) still
> makes them appear to be separate.

It wasn't clear how I could define those externally to the dm-ioctl code.

>> +     char target[24];
>> +     char target_params[256];
>
> I'm never a fan of hard-coded restrictions, but at least make them
> explicit as #defines, so people can see at a glance what to change
> if they get errors for exceeding them.

Agreed. I'll add defines or see if I can use the existing ones.
(Alternately, it might be possible to use the passed in string in place
 depending on the changes.)

>> +static void __init dm_setup_drive(void)
>
> Arguably most of this code could be a helper function exported from drivers/md.

True, or I could follow the do_mounts_md model and just use the ioctl interface.
Would a parallel function to ctl_ioctl which behaved the same but didn't expect
user-sourced dm_ioctl struct be a reasonable compromise?

That'd limit the code to parsing the parameter line and calling through without
duplicating the code in dev_create and table_load to yield the same behavior.

thanks!
will
