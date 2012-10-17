Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab2JQOKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:10:11 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:47532 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab2JQOKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:10:09 -0400
X-Greylist: delayed 3606 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Oct 2012 10:10:09 EDT
Message-id: <507EAE24.60407@verizon.net>
Date: Wed, 17 Oct 2012 09:09:56 -0400
From: Gerry Reno <greno@verizon.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615
 Thunderbird/13.0.1
MIME-version: 1.0
To: Josh Boyer <jwboyer@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michael Spang <spang@google.com>, linux-usb@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Michael Spang <spang@chromium.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>
Subject: Re: USB keyboard backlight powering down.
References: <20121016152023.GA25506@redhat.com>
 <CAC5F_1=tiGUtWOsOQ17vEYqVxuoVuoEH_nmEZ3BoL0dsgXJn3w@mail.gmail.com>
 <20121016165436.GA5140@kroah.com> <20121016173524.GG5378@xanatos>
 <20121017125538.GA2934@hansolo.jdub.homelinux.org>
In-reply-to: <20121017125538.GA2934@hansolo.jdub.homelinux.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 08:55 AM, Josh Boyer wrote:
> On Tue, Oct 16, 2012 at 10:35:24AM -0700, Sarah Sharp wrote:
>> On Tue, Oct 16, 2012 at 09:54:36AM -0700, Greg Kroah-Hartman wrote:
>>> On Tue, Oct 16, 2012 at 12:45:56PM -0400, Michael Spang wrote:
>>>> On Tue, Oct 16, 2012 at 11:20 AM, Dave Jones <davej@redhat.com> wrote:
>>>>> Gerry (CC'd) reported a bug to us that since 3.6.1, his illuminated
>>>>> Logitech USB keyboard doesn't light up until he hits a key, and then
>>>>> it immediately powers back off, defeating the purpose of having an
>>>>> illumated keyboard.
>>>>>
>>>>> Looking over the 3.6.1 changelog, I see this change, which sounds
>>>>> like it might be responsible ?
>>>>>
>>>>> commit ee537508bdc0c00b96ac497f3d82a68f820e6182
>>>>> Author: Michael Spang <spang@chromium.org>
>>>>> Date:   Fri Sep 14 13:05:49 2012 -0400
>>>>>
>>>>>     Increase XHCI suspend timeout to 16ms
>>>> I don't think this is related to your problem, as this patch is in
>>>> suspend/resume code. It just allows the controller more time to halt.
>>> Yeah, that looks odd.
>>>
>>> But, (adding linux-usb@vger), I think we enabled some "put the device to
>>> sleep if it is idle" logic for all devices, which is what is looking
>>> like is happening here.  The keyboard is being told to go to sleep in
>>> order to save power.
>>>
>>> We are saving more power, but it looks like the user wants to disable
>>> it, which makes sense for this device.
>>>
>>> So, do we do this from within the kernel with a blacklist, or rely on
>>> the user knowing how to poke the proper sysfs file to turn the keyboard
>>> back on?
>> This was the udev bug I was referring to, which I think is causing the
>> keyboard to have auto-suspend enabled:
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=825284
>>
>> udev shouldn't be enabling auto-suspend of USB hids by default, since
>> many of them don't send a wakeup to come out of suspend when they
>> should.  For example, most USB mice only send a wakeup even when they
>> are clicked, not when they are moved.  That causes the user to sit
>> there, frustrated, as they move their mouse and wonder why their screen
>> doesn't unblank.  Other keyboards also lose keystrokes, which means if
>> you pause to compose your thoughts, the first couple letters you type
>> gets dropped.
> I know we fixed that bug for F17, F18, and rawhide.  I did it myself.
> I don't think this is udev related, but we'll double check the version.
>
> Gerry, are you using udev-182-3.fc17 or newer on your F17 install?
>
> josh
>



Installed Packages
udev.x86_64                                                182-1.fc17                                               
@anaconda-0

There is an update available to 182-3 but I haven't installed it.  Didn't know what it might impact.

Gerry


