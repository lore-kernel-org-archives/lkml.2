Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2ATVje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:39:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57779 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2ATVjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:39:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120120211214.GC8162@ubuntu-macmini>
References: <20120119171808.GB23144@ubuntu-macmini>
	<CADnq5_MiLE0XSpbrd66003DVxdR9c4MgQav3BD+bWtrKvbf+7Q@mail.gmail.com>
	<20120119205317.GC23144@ubuntu-macmini>
	<20120120155318.GA8162@ubuntu-macmini>
	<CADnq5_NNpwsPoEP0_fzSJ9LQKfaHPJx90yObXKYHO39xLWM6sQ@mail.gmail.com>
	<20120120211214.GC8162@ubuntu-macmini>
Date: Fri, 20 Jan 2012 16:39:31 -0500
Message-ID: <CADnq5_NcZacne-VH-N7FQ5GQo8EbWNgi7WjeHxnJHciyaSeBvg@mail.gmail.com>
Subject: Re: radeon issues on MacBook Pro 8,2
From: Alex Deucher <alexdeucher@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 4:12 PM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> On Fri, Jan 20, 2012 at 02:38:37PM -0500, Alex Deucher wrote:
>> On Fri, Jan 20, 2012 at 10:53 AM, Seth Forshee
>> <seth.forshee@canonical.com> wrote:
>> > On Thu, Jan 19, 2012 at 02:53:17PM -0600, Seth Forshee wrote:
>> >> > >  2. Occasional long delays when suspending. When this happens I see
>> >> > >    messages like following in dmesg:
>> >> > >
>> >> > >      [drm:atom_op_jump] *ERROR* atombios stuck in loop for more than 5secs aborting
>> >> > >      [drm:atom_execute_table_locked] *ERROR* atombios stuck executing D44E (len 62, WS 0, PS 0) @ 0xD46A
>> >> > >
>> >> > >    Sometimes one of suspend or resume hangs completely, but I can't
>> >> > >    tell which and am not sure whether or not it's related. I'm also
>> >> > >    testing a Mac Mini with the exact same card which does not seem to
>> >> > >    suffer from this issue.
>> >> > >
>> >> > >    I ran a bisections that identified f8d0edd (drm/radeon/kms: improve
>> >> > >    DP detect logic) as introducing problems with suspend, and reverting
>> >> > >    this patch on top of 3.2.1 does seem to eliminate both issues.
>> >> > >
>> >> >
>> >> > That patch doesn't really affect the modesetting paths directly; it
>> >> > looks like a red herring to me.
>> >>
>> >> Perhaps. I just started a run of 200 s3 cycles with the patch reverted
>> >> to see if I can reproduce the issues. I can usually trigger the problem
>> >> with 15 or fewer s3 cycles.
>> >
>> > The machine completed 200 s3 cycles with the patch reverted without long
>> > delays, hangs, or any atombios error messages. Without reverting it
>> > doesn't get through many at all before experiencing the errors and long
>> > delays or hangs.
>> >
>> > I added a printout of the connector status resulting from the logic that
>> > was changed by f8d0edd. With the logic prior to this commit it
>> > consistently returns the status as disconnected, which is correct as I
>> > have nothing connected. But with the improved logic the status is
>> > sometimes reported as connected, and these coincide with the atombios
>> > errors.
>> >
>>
>> Do any of the disconnected displayport connectors get misdetected as
>> connected during normal operation or does it only happen during
>> suspend/resume?
>
> So far I've only seen them during suspend/resume.

Can you track down who is calling the connector->detect() callbacks
during suspend and resume?

Alex
