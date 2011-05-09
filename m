Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab1EIUVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 16:21:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60648 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab1EIUVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 16:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=S523hosHiQkMYO6YEHUSVvbCj9jksXwYe9R+wPjNCrDNTZxtOcnqBSgcFH/665+hrl
         3jtOeeckj+g/AmoGppjgm8WpLpgYPYlLp1Bndf/iFTCn0NFE9YH5ci68wFy8Wf/++jZ7
         6Nwy4lvLeQY2b7+ZyK5wd17VuS0plEYAEQ+DU=
MIME-Version: 1.0
In-Reply-To: <201105071815.03318.thomas@fjellstrom.ca>
References: <201105071815.03318.thomas@fjellstrom.ca>
Date: Mon, 9 May 2011 16:21:30 -0400
Message-ID: <BANLkTi=R0ub_zfL4A2k7unGa8X+_EeRCeQ@mail.gmail.com>
Subject: Re: long delay when using HMDI output on RS780
From: Alex Deucher <alexdeucher@gmail.com>
To: thomas@fjellstrom.ca
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 7, 2011 at 8:15 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> I just switched to using HDMI with my media center, and its causing a 30+
> second delay in the screen turning on, as well as a 7 second delay in the X
> startup when it tries to fetch the EDID information. Basically I don't get any
> picture at all once KMS initializes until after X has been up a few seconds.
>
> The odd thing is the monitor seems to think something is going on, since it
> doesn't go to sleep or display its "No Signal" OSD, but just after X starts
> up, it pops up the "Input detected/switched" OSD, and the picture appears.
>
> The bios, grub2 (in both text mode and graphics mode), and the initial linux
> kernel messages all display fine and immediately. Its only once KMS and
> radeondrmfb initializes that there's a problem (at least till X starts up).
>
> I've just built with a vanila 2.6.38.4 kernel from the stable git repo, and
> have played with some EDID settings, trying to disable edid where I could
> thinking thats what caused the problem. That doesn't seem to be the case
> though. I also tried playing with the video= kernel option, trying to force
> disable VGA-1, and set a static mode for HDMI-A-1, but if I try, it seems to
> force disable HDMI-A-1 instead of force the mode.
>
> With a DVI-D cable instead, the problem goes away.
>
> Attached are the dmesg and xorg.log files for the latest boot with HDMI (no
> video= parameter, and EDID enabled, most settings at defaults).
>
> What exactly would cause this, and is there a way I can fix it?

Most likely, the monitor doesn't like the hdmi packets it's getting
from the GPU.  If you don't need audio, boot 2.6.38 or newer with
radeon.audio=0

Alex

>
> --
> Thomas Fjellstrom
> thomas@fjellstrom.ca
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
>
