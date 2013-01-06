Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3AFUXE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:23:04 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:51397 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3AFUXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:23:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130106093649.GA17429@merkur.ravnborg.org>
References: <1356029364-11346-1-git-send-email-kliegs@chromium.org> <20130106093649.GA17429@merkur.ravnborg.org>
From: Jonathan Kliegman <kliegs@chromium.org>
Date: Sun, 6 Jan 2013 15:22:39 -0500
Message-ID: <CAPQV+nP1UJP4R8AmoUf4bt873Yz_D0ZR2msaCRx5eAc49QFodA@mail.gmail.com>
Subject: Re: [PATCH] modpost: Add flag -f for making section mismatches fatal
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tony Lindgren <tony@atomide.com>, linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 6, 2013 at 4:36 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Jonathan.
>
>> The section mismatch warning can be easy to miss during the kernel build
>> process.  Allow it to be marked as fatal to be easily caught and prevent
>> bugs from slipping in.
>>
>> Signed-off-by: Jonathan Kliegman <kliegs@chromium.org>
>
> Another way to make them much more visible would be to make
> the warnings always be verbose.

I'd like to keep the option for a hard fail if a mismatch is detected.
 This way automated build systems will detect the failed build and can
reject a chan

> In other words drop support for the "-S" options used below:
>>   $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)
>
> Previously the dev* stuff caused a lot of warnings, but
> since we have HOTPLUG always enabled this is a non-issue.
> So I think that this is a good time to enable the verboce
> warnings.
I can submit a second patch for this if you'd like, but I'm not
familiar with all the previous decisions in this area.  If I
understand correctly we'll still need the config option as it also
changes compiler flags for inlining.
>
>         Sam
