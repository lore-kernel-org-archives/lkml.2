Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab0LPP4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:56:08 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:54295 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab0LPP4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:56:05 -0500
Date: Thu, 16 Dec 2010 17:55:54 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Felipe Balbi <balbi@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bob Liu <lliubbo@gmail.com>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
Message-ID: <20101216155554.GA9552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20101216140122.ca745f1f.sfr@canb.auug.org.au>
 <20101216030857.GA12785@kroah.com>
 <20101216080527.GA2601@legolas.emea.dhcp.ti.com>
 <20101216084552.GD2601@legolas.emea.dhcp.ti.com>
 <20101216155225.GA31363@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20101216155225.GA31363@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 16, 2010 at 07:52:25AM -0800, Greg KH wrote:
>On Thu, Dec 16, 2010 at 10:45:52AM +0200, Felipe Balbi wrote:
>> Hi,
>>
>> On Thu, Dec 16, 2010 at 10:05:27AM +0200, Felipe Balbi wrote:
>> >On Wed, Dec 15, 2010 at 07:08:57PM -0800, Greg KH wrote:
>> >>On Thu, Dec 16, 2010 at 02:01:22PM +1100, Stephen Rothwell wrote:
>> >>>Hi Greg,
>> >>>
>> >>>Today's linux-next merge of the usb tree got a conflict in
>> >>>drivers/usb/musb/blackfin.c drivers/usb/musb/musb_core.c
>> >>>drivers/usb/musb/musb_core.h between commit
>> >>>1e393c6eece048052d4131ec4dad3b98e35a98e2 ("USB: musb: blackfin: pm: make
>> >>>it work") from Linus' tree (v2.6.37-rc2) and various commits from the usb
>> >>>tree.
>> >>>
>> >>>It was not immediately obvious how to fix these up, so I just used the
>> >>>versions from the usb tree.  This may not be correct and it would be good
>> >>>if this was fixed properly in the usb tree.
>> >>
>> >>Hm.  Felipe, I'll merge in the -rc4 tree into usb-next if it makes sense
>> >>to do so now, can you send me the patch that ends up being the correct
>> >>merge?
>> >
>> >Sure, I'll check it now and send in a patch in a few minutes.
>>
>> There are two commits you didn't have in your usb-next branch which are
>> in mainline. Reverting them will make greg/usb-next apply cleanly on top
>> of v2.6.47-rc4. The commits are:
>>
>> 32d5dc9520f0c6f60f691dd478741c774e292406 : USB: musb: pm: don't rely fully on clock support
>> 1e393c6eece048052d4131ec4dad3b98e35a98e2 : USB: musb: blackfin: pm: make it work
>>
>> Do you want me to rebase on top of -rc4 or is reverting those two enough
>> for you ? As a sidenote, the series I sent you already fixes those two
>> cases as we moved PM and clock handling entirely to glue layer, so those
>> two cases are taken care of on the series, reverting those patches won't
>> pose any regressions.
>
>So, I should do the following things:
>	take -rc6
>	revert the above commits
>	merge with usb-next
>	push out
>
>and all should be good, right?  If so, that's fine with me, I'll do it

Perfect, I just tried again just to be sure Merges cleanly:

commit 6033eb6e16e602f97ac5b6424ef71c8e464ececc
Merge: fa05820 0b83ae9
Author: Felipe Balbi <balbi@ti.com>
Date:   Thu Dec 16 17:55:14 2010 +0200

     Merge remote-tracking branch 'greg/usb-next' into linus

-- 
balbi
