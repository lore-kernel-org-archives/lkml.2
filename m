Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2FOIXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:23:14 -0400
Received: from hera.cwi.nl ([192.16.191.8]:48850 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752382Ab2FOIXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:23:12 -0400
Message-ID: <4FDAF0E5.3040005@cwi.nl>
Date: Fri, 15 Jun 2012 09:23:01 +0100
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: "Brown, Len" <len.brown@intel.com>
CC: Dave Airlie <airlied@gmail.com>,
        "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>,
        "intergalactic.anonymous@gmail.com" 
	<intergalactic.anonymous@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Zhang, Rui" <rui.zhang@intel.com>
Subject: Re: [3.4 regression] [bisected] DisplayPort fails to come on
References: <4FD9E69A.4090708@cwi.nl> <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com> <1A7043D5F58CCB44A599DFD55ED4C9481FCA16A8@FMSMSX108.amr.corp.intel.com>
In-Reply-To: <1A7043D5F58CCB44A599DFD55ED4C9481FCA16A8@FMSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 10:52 PM, Brown, Len wrote:
> Please test the latest patch here:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=43168
(Now without the HTML)

Hi Len,

First let me apologise for the confusion. I grouped two error messages 
that apparently are not related:
kernel: video: probe of LNXVIDEO:00 failed with error -5
kernel: [drm:intel_dp_complete_link_train] *ERROR* failed to train DP, 
aborting

We resolved my problem (a blank second monitor attached to the 
displayport) and got rid of the second error message by reverting 
092945e11c5b84f66dd08f0b87fb729715d377bc.

The first message remains, and I interpret your suggestion as trying to 
get rid of that too. The difficulty for me is that I do not see any 
symptoms resulting from this error message. In particular the backlight 
controls (Fn-F4/5) work fine. I do not know what

/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2c/LNXVIDEO:00/input/input4

means, how I activate it, and what goes awry when its probing fails.

Then again, I think there must be something to your pointer, since I see 
indeed in dmesg
[Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS


At any rate, without that patch this error message is displayed:

kernel: video: probe of LNXVIDEO:00 failed with error -5

With the patch I see instead
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2c/LNXVIDEO:00/input/input4

That does look more friendly, but I am at a loss  to tell you what really got improved. Please help.

Wouter

