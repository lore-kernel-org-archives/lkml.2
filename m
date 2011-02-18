Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab1BRMEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 07:04:42 -0500
Received: from dalsmrelay2.nai.com ([205.227.136.216]:16321 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1BRMEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 07:04:38 -0500
Message-ID: <4D5E5FB1.1000404@snapgear.com>
Date: Fri, 18 Feb 2011 22:01:53 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Steven King <sfking00@yahoo.com>,
        uClinux development list <uclinux-dev@uclinux.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: merge of m68knommu and m68k arch branches?
References: <4D5DB83D.80205@snapgear.com> <20110218074401.GA26836@merkur.ravnborg.org>
In-Reply-To: <20110218074401.GA26836@merkur.ravnborg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2011 12:02:49.0699 (UTC) FILETIME=[C363A330:01CBCF63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 18/02/11 17:44, Sam Ravnborg wrote:
> On Fri, Feb 18, 2011 at 10:07:25AM +1000, Greg Ungerer wrote:
>>
>> Hi All,
>>
>> I would like to put up for discussion a merge of the m68knommu and
>> m68k arch branches.
>>
>> Attached is a script and patch that does a kind of brute force
>> simplistic merge of the directories and files. (Thanks to Stephen King
>> <sfking@fdwdc.com>  for the initial version of this script, and to
>> Sam Ravnborg for the m68k includes merge script this was based on).
>> Nothing outside of the arch/m68k and arch/m68knommu directories is
>> touched, and in the end there is no more arch/m68knommu. To apply you
>> simply run the script from the top of a current kernel git tree (I used
>> 2.6.38-rc5 for testing) and then apply the patch.
>
> The initial version of said script was created by Arnd IIRC.

Apologies to Arnd then :-)


>> Thoughts?
> When we merged x86, sh and sparc in the past this has in all
> cases helped sharing coe between the 32 and 64 bit variants.
> There has in all cases been some code-chrunch in the beginning,
> but the result has been good.
> What as often caused some troubles has been how to configure
> the individual architectures.
>
> We have for eaxample:
> make ARCH=x86, make ARCH=i386, make ARCH=x86_64 today.
>
> Likewise for sparc we have:
> make ARCH=sparc, make ARCH=sparc32, make ARCH=sparc64
>
> So you need to consider how to deal with this for m68k.
> Maybe MMU is just an option so you only have ARCH=m68k in the end?

That is what I have currently done. CONFIG_MMU is selectable,
and there is no longer a separate ARCH=m68knommu, only ARCH=m68k.
I am fine with that, but I am interested in what opinion others
have on this.


> You do not touch upon the maintenance of the merged trees.
> Today there is different maintainers for the two archs.
> To have a transparent flow the better solution is likely that
> all m68k* patches go via one of your trees so we do not
> have two trees that deal with m68k upstream.

Yeah, I had much thought to this yet.


> I assume we will sort it all out naturally and I hope that
> we soon will have m68k and m68knommu merged!

That would be my take on it ;-)
I am happy to charge ahead and let the maintenance/flow work
itself out.

Thanks
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close                             FAX:         +61 7 3217 5323
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
