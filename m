Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1BXNLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:11:15 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2151 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1BXNLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:11:14 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Message-ID: <4D6658D7.1010501@broadcom.com>
Date: Thu, 24 Feb 2011 14:10:47 +0100
From: "Roland Vossen" <rvossen@broadcom.com>
Organization: Broadcom
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13)
 Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Greg KH" <gregkh@suse.de>
cc: "Arend Van Spriel" <arend@broadcom.com>,
        "Ben Hutchings" <ben@decadent.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "Brett Rudley" <brudley@broadcom.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "stable-review@kernel.org" <stable-review@kernel.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Stable-review] [28/70] staging: brcm80211: bugfix for
 softmac crash on multi cpu configurations
References: <20110222221839.853712243@clark.kroah.org>
 <1298427787.2211.498.camel@localhost> <op.vrciafbg3ri7v4@arend-laptop>
 <20110223180627.GB30106@suse.de> <op.vrdhl9qk3ri7v4@arend-laptop>
In-Reply-To: <op.vrdhl9qk3ri7v4@arend-laptop>
X-WSS-ID: 617886D25OK11782985-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

>> So, what should I do here?  Drop the referenced patch from the
>> .37-stable queue, or do you have the text for the changelog that I
>> should use here instead?
>>
>> confused,
>>
>
> Dito here. I submitted a patch for the stable kernel and Roland did one
> (if I am correct). I have no clue how his commit message came with my
> patch or vice versa.
>

Let me try to clear up part of the confusion.

The short story is: for some mysterious reason, a patch exists that is a 
mixup of two patches (one from Arend and one from me). It contains the 
commit message from me, but the file changes from Arend. This 'hybrid' 
patch was submitted for review by you. This patch did not make it yet 
into the 2.6.37-stable tree.

Also, neither Arends nor my Patch ended up in the 2.6.37-stable tree.

To fix this problem, I think that this hybrid patch has to be review 
rejected. Next, new patches have to be created based on Rolands patch 
(6a3be6e6e7feb4cb35275475d6a863b748d59cc3, as submitted into 
gregkh/staging-2.6.git::staging-linus branch) as well as Arends patch 
(d062d44a8386c82c06e483f0c0d1124ba3cab2c8). These patches would then 
have to be reviewed for the 2.6.37-stable tree.

-------------- Long story follows:

Both Arend and I submitted a patch for the 2.6.38 tree 
(gregkh/staging-2.6.git). The commits were:

commit d062d44a8386c82c06e483f0c0d1124ba3cab2c8
Author: Arend van Spriel <arend@broadcom.com>
Date:   Fri Jan 21 13:34:15 2011 +0100
staging: brcm80211: remove assert to avoid panic since 2.6.37 kernel

and:

commit 6a3be6e6e7feb4cb35275475d6a863b748d59cc3
Author: Roland Vossen <rvossen@broadcom.com>
Date:   Tue Jan 25 11:51:56 2011 +0100
staging: brcm80211: bugfix for softmac crash on multi cpu configurations

Rolands patch was added to the 2.6.37 tree since I got the following 
email from you:

-------- Original Message --------
Subject: Patch "staging: brcm80211: bugfix for softmac crash on multi 
cpu configurations" has been added to the 2.6.37-stable tree
Date: Wed, 16 Feb 2011 15:06:28 -0800
From: gregkh@suse.de <gregkh@suse.de>
To: Roland Vossen <rvossen@broadcom.com>, Arend Van Spriel 
<arend@broadcom.com>, Brett Rudley <brudley@broadcom.com>, 
"gregkh@suse.de"	<gregkh@suse.de>
-------- /Original Message --------

I do not see a similar email for Arends patch.

Now something strange happened: I see a patch that is a hybrid: I bears 
Rolands patch title with Rolands commit message, but the files touched 
are related to Arends patch. See: 
http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=review-2.6.37/staging-brcm80211-bugfix-for-softmac-crash-on-multi-cpu-configurations.patch;h=e0315e2ecaf4671256c39a491b2b623ade9d0e7b;hb=HEAD

I checked if my file changes are present in the 2.6.37 stable tree, 
which I would expect, but they are not, at least not when I look at: 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=blob;f=drivers/staging/brcm80211/sys/wl_mac80211.c;h=cb2041a61d78a78eea4ff8a71896ba2cff21bcda;hb=HEAD

Arends changes are also not present in the 2.6.37 stable tree: 
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=blob;f=drivers/staging/brcm80211/sys/wlc_mac80211.c;h=feaffcc64ec6f7889168d2de1a811d867a2f91a8;hb=HEAD

Bye, Roland.


