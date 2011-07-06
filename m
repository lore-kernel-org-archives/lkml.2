Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab1GFPmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:42:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61447 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab1GFPmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:42:43 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
References: <1308866743-8066-1-git-send-email-reimth@gmail.com>
	<1309946963-6409-1-git-send-email-reimth@gmail.com>
	<CADnq5_M5NAd2PVbS0FPB_VSmg8+41HUsDL1TcbKK94GK6MF_jA@mail.gmail.com>
Date: Wed, 6 Jul 2011 11:42:42 -0400
Message-ID: <CADnq5_M2yy2aota_mbvq4jKns-sQBOLfJrOzQuNOREw=FfgfOg@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Fix Asus M2A-VM HDMI EDID error flooding problem
From: Alex Deucher <alexdeucher@gmail.com>
To: reimth@googlemail.com
Cc: Dave Airlie <airlied@redhat.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jean Delvare <khali@linux-fr.org>,
        Tyson Whitehead <twhitehead@gmail.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Thomas Reim <rdratlos@yahoo.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 11:39 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Wed, Jul 6, 2011 at 6:09 AM,  <reimth@googlemail.com> wrote:
>> From: Thomas Reim <rdratlos@yahoo.co.uk>
>>
>>    Some integrated ATI Radeon chipset implementations
>>    with add-on HDMI card (e. g. Asus M2A-VM HDMI) indicate the availability
>>    of a DDC even when the add-on card is not plugged in or HDMI is disabled
>>    in BIOS setup. In this case, drm_get_edid() and drm_edid_block_valid()
>>    periodically dump data and kernel errors into system log files and onto
>>    terminals. For these chipsets DDC probing is extended by a check for a
>>    correct EDID header. Only in case a valid EDID header is also found, the
>>    (HDMI) connector will be used by the Radeon driver. This prevents the
>>    kernel driver from useless flooding of logs and terminal sessions with
>>    EDID dumps and error messages.
>>    This patch adds a flag 'requires_extended_probe' to the radeon_connector
>>    structure. In function radeon_connector_needs_extended_probe() this flag
>>    can be set on a chipset family/vendor/connector type specific basis.
>>    In addition, function drm_edid_header_is_valid() has been added for EDID
>>    header check and function radeon_ddc_probe() has been adapted to perform
>>    extended DDC probing if required by the connector's flag.
>>
>>    Tested for kernel 2.35, 2.38 and 3.0 on Asus M2A-VM HDMI board
>>
>
> Once it's ready, just add:
> Cc: stable@kernel.org
> to the commit message and it will go into the stable kernels as well.
> Might want to mention the bug report in your commit message as well.
> Just a couple comments below.  With those fixed:
>
> Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

We also may want to revert 4a9a8b71e12d41abb71c4e741bff524f016cfef4
once this patch goes in, otherwise we may remove the ddc bus
unnecessarily on some systems.

Alex
