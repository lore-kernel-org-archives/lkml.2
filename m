Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab2DCIig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 04:38:36 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2DCIid convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 04:38:33 -0400
MIME-Version: 1.0
In-Reply-To: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
References: <1333436730-13008-1-git-send-email-rydberg@euromail.se>
Date: Tue, 3 Apr 2012 10:38:32 +0200
Message-ID: <CAN+gG=EvmTFKmKGaC6T-RKYhUy8U0NqWxqz-k_Gr_w5_rm57Bg@mail.gmail.com>
Subject: Re: [RFC 0/5] hid: Extending the device-driver matching mechanism
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

well, I'm giving you my answer here as it will be more convenient than
in the previous thread.

So, I made a few tests yesterday, and I have now a clearer idea about
this solution:

generally, I like it. Furthermore, it should help us build new classes
of devices without involving hid-core, which is great.
However, I have a few minors concerns, and a major one.

The major one comes with patch 3: introducing the hid_parse function
in usbhid is great but it interferes with report_fixup mechanism. That
means that several drivers won't work with this solution.

Now the minors:
- as mentioned, the patches do not apply on Jiri's tree, which means
that we are missing the detection of the serial protocol (see comment
in patch 4).
- shouldn't we introduce the same behavior for bluetooth (hidp)
devices -> to be able to separate the handling of the magicmouse for
instance)?
- as the hid_parse function is already called, shouldn't we remove the
calls in the other drivers?

Cheers,
Benjamin

On Tue, Apr 3, 2012 at 09:05, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Jiri,
>
> These patches were first sent out as a reply to Benjamin's autoloading
> patch (http://www.spinics.net/lists/linux-input/msg20001.html), but it
> seems more appropriate as an RFC.
>
> The idea is to parse the hid descriptors before adding the device,
> such that the device identifier, in particular the device/modalias,
> can be augmented by the report information. This approach solves the
> generic auto-loading problem we face today, here exemplified by a
> solution for hid-multitouch.
>
> The patches apply cleanly to 3.3 for easy testing.
>
> Thanks,
> Henrik
>
> Henrik Rydberg (5):
>  hid: Remove multitouch quirk
>  hid-multitouch: Prepare driver for new device ids
>  hid: Parse the device before adding it
>  hid: Add idtags to modalias
>  hid: Remove multitouch devices from blacklist
>
>  drivers/hid/hid-core.c          |   88 ++++++++-------------------
>  drivers/hid/hid-input.c         |   11 ----
>  drivers/hid/hid-multitouch.c    |  124 +++++++++++++++++++++------------------
>  drivers/hid/usbhid/hid-core.c   |    5 ++
>  include/linux/hid.h             |    8 ++-
>  include/linux/mod_devicetable.h |    2 +-
>  scripts/mod/file2alias.c        |    2 +
>  7 files changed, 107 insertions(+), 133 deletions(-)
>
> --
> 1.7.9.5
>
