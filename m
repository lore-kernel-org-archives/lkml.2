Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab1CHQWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 11:22:30 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50129 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1CHQW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 11:22:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EGDSHWEaeGTN2z0sQEU/VN81zPyXXuD/3AbId5QZoo4BInI/T3I9eKkGhi5nOUWu61
         B8oVGrdqOk5XYXGsdGRA/3pVrdGUnWVF3sUVIxANPA5Kg61FWqw/vbW9/LNrnmw0LIXz
         z7RITSHY3P7L21cbTSrrFMYicKUOr+0ltumbE=
MIME-Version: 1.0
In-Reply-To: <1299597447.4676.25.camel@jlt3.sipsolutions.net>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	<20110304134648.GB9866@tuxdriver.com>
	<1299251879.24333.3.camel@wwguy-ubuntu>
	<AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	<AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
	<AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
	<1299334144.3826.8.camel@jlt3.sipsolutions.net>
	<AANLkTikQHUq95e9=3tG5WrayaxUu+K1FdAftJ3y72BTn@mail.gmail.com>
	<1299597447.4676.25.camel@jlt3.sipsolutions.net>
Date: Tue, 8 Mar 2011 16:22:27 +0000
Message-ID: <AANLkTinj1f0Kx5X6eqYEdyzT_3XLbtbLtwbp7jPN2LSH@mail.gmail.com>
Subject: Re: 2.6.38-rc7, iwlagn warning
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 March 2011 15:17, Johannes Berg <johannes@sipsolutions.net> wrote:
> FWIW, I'm changing the subject since "crash" bothers me, it's not even
> close to a crash.

Of course, sorry.

> On Sat, 2011-03-05 at 23:45 +0000, Mathias Burén wrote:
>
>> I got it again, with the newly compiled kernel. However, I've been
>> trying for 20 minutes now and when I load iwlagn with the debug
>> parameter I can't seem to get the warning. I was monitoring dmesg with
>> "watch --interval=1 "dmesg|tail -n40"" but I never saw the warning. As
>> soon as I removed the module, and inserted it again without the debug
>> option I could reproduce the warning. Here are some dmesg logs:
>
> Curious.
>
>> no debug, crash 1: http://www.privatepaste.com/download/06539404a8
>> no debug, crash 2: http://www.privatepaste.com/download/a6be5f5c81
>
> And I'd prefer if you also stopped using the word crash. Nothing
> crashed. All you got was a stack trace because I put a warning there.
> Really, not the end of the world, and in fact it probably has very
> little or even no effect on functionality.
>

Got it.

> However ... actually looking at the log files I'm totally confused what
> it is that you're doing. Something appears to be continually switching
> between interface modes, even using wireless extensions, yet it really
> wants to be IBSS all the time. What's causing all this pointless
> switching? It'd be useful to figure that out, but I'm not sure how. What
> applications are you running that manage wireless? Are you, by any
> chance, running wpa_supplicant manually in addition to network-manager?

I'm using NetworkManager, I haven't started anything else manually. I
don't know why it switches modes like that, it happens on 2 laptops
(both Ubuntu 10.10) so it could very well be some NetworkManager
related issue.

> Irregardless of that though, there's clearly some kind of bug in the
> driver since the TX power setting times out, and then as a result we get
> the warning.
>
> Would you be willing to enable tracing and capture a trace using
> trace-cmd, by running 'trace-cmd record -e mac80211 -e iwlwifi'?
>
> johannes
>
>

I've since upgraded to 2.6.38-rc8 (same config). Looking around in the
config, is it CONFIG_FUNCTION_TRACER I need to enable, and is that it?
(kernel function tracer)

// Mathias
