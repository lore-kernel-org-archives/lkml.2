Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762148Ab2KCAVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 20:21:10 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49671 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753422Ab2KCAVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 20:21:07 -0400
Message-ID: <5094636A.9050000@virtuousgeek.org>
Date: Fri, 02 Nov 2012 17:20:58 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 1/2] PM: make VT switching to the suspend console optional
References: <1351892621-4840-1-git-send-email-jbarnes@virtuousgeek.org> <1351892621-4840-2-git-send-email-jbarnes@virtuousgeek.org> <20121102234302.28b773a7@pyramind.ukuu.org.uk>
In-Reply-To: <20121102234302.28b773a7@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/2012 4:43 PM, Alan Cox wrote:
> On Fri,  2 Nov 2012 14:43:40 -0700
> Jesse Barnes<jbarnes@virtuousgeek.org>  wrote:
>
>> KMS drivers can potentially restore the display configuration without
>> userspace help.  Such drivers can set a new global, pm_vt_switch, to
>> false if they support this feature.  In that case, the PM layer won't VT
>> switch to the suspend console at suspend time and then back to the
>> original VT on resume, but rather leave things alone for a nicer looking
>> suspend and resume sequence.
>
> What if you are multi-head ? What are the locking rules for a suspend/kms
> module unload race, what happens when you load/unload and hand over
> multiple frame buffers ? What if you have vts split across two adapters ?
>
> Put me down as 100% in favour of the feature but we need to be a bit more
> careful about the implementation. The logic probably needs to be in the
> vt layer.
>
> I suspect we actually need a per vt flag for this, or a flag on the
> underlying object below the vt somewhere.
>
> So NAK for the implementation ACK for the idea.

Yeah good points, I didn't consider multi-head/VT split configurations 
at all obviously.  We can probably stuff something into the VT layer for 
that, but how would I even configure a VT split across two adapters 
today?  For vgacon we just route VGA to a single adapter, but I'm not 
sure how that works for fbcon.  Does it properly support multihead?  I 
thought not...

Dunno about suspend vs unload, how do we deal that in other drivers like 
the disk driver for suspend for example?  Overall that case seems pretty 
esoteric...

What do you mean about hand over to multiple frame buffers?

Jesse

