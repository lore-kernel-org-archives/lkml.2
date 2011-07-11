Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab1GKH3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 03:29:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63214 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1GKH3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 03:29:50 -0400
MIME-Version: 1.0
In-Reply-To: <20110707151023.GA15366@srcf.ucam.org>
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com> <20110707151023.GA15366@srcf.ucam.org>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <kengyu@canonical.com>
Date: Mon, 11 Jul 2011 15:29:09 +0800
X-Google-Sender-Auth: oHeFbw5wiewPaByxow2ajw9spvo
Message-ID: <CADXHx7bnQ49yrL2Uoq=945V1UWMPq-FamCOT81t7Jn4mtEHpkQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ideapad-laptop: Ignore an unused VPC notification
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        ike.pan@canonical.com, vanhoof@canonical.com, kent.lin@canonical.com,
        sylee@canonical.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 7, 2011 at 11:10 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 28, 2011 at 02:35:53PM +0100, Keng-Yu Lin wrote:
>> BIOS fires notifications in a constant period with VPC bit 1 set when the
>> power cord is unplugged.
>
> How frequently? That's going to do bad things to power management. It'd
> be nice to find a way to just make it stop doing that.
>

About every 22 seconds.

May 18 13:46:36 ubuntu-Rev-1-0 kernel: [ 1359.734293] keyboard: can't
emulate rawmode for keycode 240
May 18 13:46:36 ubuntu-Rev-1-0 kernel: [ 1359.734324] keyboard: can't
emulate rawmode for keycode 240
May 18 13:46:58 ubuntu-Rev-1-0 kernel: [ 1382.195371] keyboard: can't
emulate rawmode for keycode 240
May 18 13:46:58 ubuntu-Rev-1-0 kernel: [ 1382.195388] keyboard: can't
emulate rawmode for keycode 240
May 18 13:47:21 ubuntu-Rev-1-0 kernel: [ 1404.650451] keyboard: can't
emulate rawmode for keycode 240
May 18 13:47:21 ubuntu-Rev-1-0 kernel: [ 1404.650470] keyboard: can't
emulate rawmode for keycode 240
May 18 13:47:43 ubuntu-Rev-1-0 kernel: [ 1427.103195] keyboard: can't
emulate rawmode for keycode 240
May 18 13:47:43 ubuntu-Rev-1-0 kernel: [ 1427.103214] keyboard: can't
emulate rawmode for keycode 240
May 18 13:48:06 ubuntu-Rev-1-0 kernel: [ 1449.568874] keyboard: can't
emulate rawmode for keycode 240
May 18 13:48:06 ubuntu-Rev-1-0 kernel: [ 1449.568884] keyboard: can't
emulate rawmode for keycode 240
May 18 13:48:28 ubuntu-Rev-1-0 kernel: [ 1472.103599] keyboard: can't
emulate rawmode for keycode 240
May 18 13:48:28 ubuntu-Rev-1-0 kernel: [ 1472.103612] keyboard: can't
emulate rawmode for keycode 240

(skip)


It'd be ideal if we can find the real use of the notification and
assign it a corresponding keycode, but now I am not able to find any.

Since it occurs in a period when AC cord unplugged, I suspect it is
just a notification to the Windows App, probably due to that the App
is badly written and the App does not want to poll the battery
information. In Linux the userspace can access the battery information
in an easier way through the ACPI proc/sysfs and it is probably not
true in Windows. It could be the reason/purpose why this notification
is sent in a period.

If so, it should be safe to filter out.
