Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1LTXnS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:43:18 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:62087 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603Ab1LTXnQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:43:16 -0500
MIME-Version: 1.0
In-Reply-To: <20111221001031.539ef397@stein>
References: <20111220213017.75ff380c@stein> <20111220213120.5e275f10@stein>
 <CADmzSSjfFgrAroh8jZfC-q0dNuDgsyoNcUfTik6gBx75zrngFw@mail.gmail.com> <20111221001031.539ef397@stein>
From: Carl Karsten <carl@personnelware.com>
Date: Tue, 20 Dec 2011 17:42:54 -0600
X-Google-Sender-Auth: dACWg5KzGMTsmgYGCyAFh0dsl8I
Message-ID: <CADmzSShYiyP3okwu51P3XoZOs89F-ChUJCmVuO=4ZS31PZjvUA@mail.gmail.com>
Subject: Re: [PATCH 1/3] firewire: do not expose globally unique IDs in the
 kernel log
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 5:10 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> On Dec 20 Carl Karsten wrote:
>> grumble.
>>
>> I use those guids like so:
>>
>> plug in dv cam, dmesg, cut guid to clipboard, run:
>> dvgrab -guid (paste)
>
> How about:
>
>        #!/bin/sh
>        guid=$(cat /sys/bus/firewire/devices/$1/guid)
>        shift
>        dvgrab -guid $guid "$@"
>
> To be called as "dvgrab-wrapper fw3 [more dvgrab options]", with fw3 being
> the device of your choice, e.g. the one that just scrolled by in syslog.
>
> Or you run "grep . /sys/bus/firewire/devices/*/guid | sed s/\\/guid:/\\t/"
> before dvgrab, and you get a list of GUIDs from which you can copy and
> paste.

I can't rely on these scripts being available, and I certainly won't
to try and create them on the fly when I need them (which is often as
a talk is starting and I am already in a panic trying to figure out
why something isn't working... every second counts, and my brain is
topped out.)

>
>> It also kinda helps me keep track of what devices are misbehaving, but
>> this alone isn't very important.
>>
>> Any chance of making this configurable?
>
> So far the configuration of the "new" firewire drivers were kept at an
> essential minimum, and I am hesitant to add more baroque ones.  I would
> rather drop this patch now that there was negative feedback, unless there
> is going to be positive feedback as well.

+1.

As a peace offering to people that want to x them out before posting:

juser@pc8:~$ sed -r 's/(GUID
[0-9A-Fa-f]{8})[0-9A-Fa-f]{8}/\1xxxxxxxx/' /var/log/syslog

snip snip
Dec 20 08:30:00 pc8 kernel: [    1.980149] firewire_core: created
device fw0: GUID 00241b00xxxxxxxx, S100

-- 
Carl K
