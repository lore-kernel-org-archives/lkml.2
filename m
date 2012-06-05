Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2FEFE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 01:04:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54329 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2FEFE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 01:04:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7ivA4NpTv8jT=sxe9qAEZZ89qm6km+WBGq1UZK1Uhz8A@mail.gmail.com>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org>
	<CAE9FiQXx_x9M5ncLk4DyL8heYQTcsHZt2JofFMjPfUd4mympeA@mail.gmail.com>
	<CAE9FiQX=ECg5BmKm7B2ua_rZ6bOsceeHNsfFQRWBbNZx+8sBfw@mail.gmail.com>
	<20120525043651.GA1391@google.com>
	<CAE9FiQXvYH4zCqp_uOb2nw7jvm8B=q3yx1tCjJUT+PkdymYEuw@mail.gmail.com>
	<CAE9FiQW0rm2_sKdSCWs3TfatJB9yHwvmvt9_vBYMtOq_YBbmfw@mail.gmail.com>
	<20120525193716.GA8817@google.com>
	<CAE9FiQWrZaBpT1fzC_-mSBfDd4AKGrdGomPxVNSU-SFPrVNvOw@mail.gmail.com>
	<CAErSpo7d+zn-qgWKcbro7yneXRtmZQCOHi+kiGzYUTfs+aiF4g@mail.gmail.com>
	<CAE9FiQUWWO75WP3gYRwYbyO_ZiWwyjKnzMxOGhfjY4H98w2Hbw@mail.gmail.com>
	<CAErSpo46fCCFCijNfMzGYP__pP6hkPFurMS=1=wSAZsg5z0-Lg@mail.gmail.com>
	<CAE9FiQWUrkKEpLmEn9kzkKOtEtX7-R8shdVSKGgSyHezKpzJCw@mail.gmail.com>
	<4FC50E09.4000204@zytor.com>
	<CAE9FiQUtio=dut3A9+jCcsgUWEeNYcpqLP6RpqGOZUfPPAtHWw@mail.gmail.com>
	<4FC51D79.6010804@zytor.com>
	<CAE9FiQUWMAdU5jtKfq1_=1E-574gW-Afo8Pby49mUFQYFrs9Pw@mail.gmail.com>
	<4FC536A5.6020600@zytor.com>
	<CAE9FiQXi23-mY6p2Dr1EJmukhTSPxvBGtjvQ8wyJYPDS+6o5ZA@mail.gmail.com>
	<CAErSpo67h_mdZtoEn-W_OOXZ8m7gs3g6Q25kte285ZX=2FKf+A@mail.gmail.com>
	<CAE9FiQV7jpBWkcXy2vgixnxx2fhid28Wj0iHAhGkVVdQn6epNQ@mail.gmail.com>
	<CAErSpo7ivA4NpTv8jT=sxe9qAEZZ89qm6km+WBGq1UZK1Uhz8A@mail.gmail.com>
Date: Mon, 4 Jun 2012 22:04:57 -0700
X-Google-Sender-Auth: rLPGDYABzhz30qo0V0TxxZ_BEG4
Message-ID: <CAE9FiQWbET=awz9o=6JBwonv_obe5KzRPNXjowNtFWrN3_4T_w@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Newbury <steve@snewbury.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 9:50 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Jun 4, 2012 at 7:37 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> On Sun, Jun 3, 2012 at 6:05 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> On Fri, Jun 1, 2012 at 4:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>>> On Tue, May 29, 2012 at 1:50 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>>>
>>>>> The bus-side address space should not be more than 32 bits no matter
>>>>> what.  As Bjorn indicates, you seem to be mixing up bus and cpu
>>>>> addresses all over the place.
>>>>
>>>> please check update patches that is using converted pci bus address
>>>> for boundary checking.
>>>
>>> What problem does this fix?  There's significant risk that this
>>> allocation change  will make us trip over something, so it must fix
>>> something to make it worth considering.
>>
>> If we do not enable that, we would not find the problem.
>
> Sorry, that didn't make any sense to me.  I'm hoping you will point us
> to a bug report that is fixed by this patch.

current it only help Steve's test case.

>
>> On one my test setup that _CRS does state 64bit resource range,
>> but when I clear some device resource manually and let kernel allocate
>> high, just then find out those devices does not work with drivers.
>> It turns out _CRS have more big range than what the chipset setting states.
>> with fixing in BIOS, allocate high is working now on that platform.
>
> I didn't understand this either, sorry.  Are you saying that this
> patch helps us work around a BIOS defect?

Help us find out one BIOS defect.

>
>> yeah, how about
>>
>> pci=alloc_high
>>
>> and default to disabled ?
>
> I was actually thinking of something more specific, e.g., a way to
> place one device at an exact address.  I've implemented that a couple
> times already for testing various things.  But maybe a more general
> option like "pci=alloc_high" would make sense, too.

yeah.

>
....
> Linux has a long history of allocating bottom-up.  Windows has a long
> history of allocating top-down.  You're proposing a third alternative,
> allocating bottom-up starting at 4GB for 64-bit BARs.  If we change
> this area, I would prefer something that follows Windows because I
> think it will be closer to what's been tested by Windows.  Do you
> think your alternative is better?

hope we can figure out how windows is making it work.

Steve, Can you check if Windows is working with your test case ?

If it works, we may try do the same thing from Linux, so you will not need to
append "pci=nocrs pci=alloc_high"...

Thanks

Yinghai
