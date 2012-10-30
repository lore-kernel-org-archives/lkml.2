Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933078Ab2J3LwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 07:52:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:6788 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933000Ab2J3LwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 07:52:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,679,1344236400"; 
   d="scan'208";a="212938215"
From: Jani Nikula <jani.nikula@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915: failure to interoperate with HP ZR30w using an X230
In-Reply-To: <87hapcqu97.fsf@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <nsxa9v4ssgz.fsf@closure.thunk.org> <87hapcqu97.fsf@intel.com>
User-Agent: Notmuch/0.14+49~gd2c7aec (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 30 Oct 2012 13:57:27 +0200
Message-ID: <87zk34gok8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2012, Jani Nikula <jani.nikula@intel.com> wrote:
> Hi Ted -
>
> On Tue, 30 Oct 2012, Theodore Ts'o <tytso@mit.edu> wrote:
>> I recently upgraded to 3.6.3, and my Lenovo X230 has stopped being able
>> to work with an HP ZR30w 30" 2560x1600 display.   I saw the following
>> messages in the dmesg:
>>
>> [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 1 fail!
>> [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 2 fail!
>>
>> .. which I didn't see before; the exact same mini-displayport to
>> displayport cable connecting the same Lenovo X230 laptop to exactly the
>> same ZRW 30 display worked just fine with the 3.6.0 kernel.
>>
>> So I bisected the problem, and found the following commit.  Reverting
>> this commit made the problem go away.   Maybe we should revert
>> 0c96c65b48fb in mainline?
>
> Thanks for bisecting. However, the commit does fix a bug for some people
> out there, which is why it's been backported to stable. Without it, we
> fail to dither when there is not enough bandwidth in the DP link. My
> guess is that this brings up another bug that affects you, and IMHO we'd
> be better off debugging this than reverting.
>
>> Let me know if you'd like me to do any further debugging.
>
> Something to try would be the latest i915.ko driver [1], which I believe
> has some link training changes, and/or posting the dmesg with
> drm.debug=0xe module parameter.
>
> BR,
> Jani.
>
>
> [1] drm-intel-next-queued branch at git://people.freedesktop.org/~danvet/drm-intel

Hmm, actually not. Either drm-intel-fixes branch, or Linus' master.

Daniel, 'git tag --contains 0c96c65b48fba3ffe9822a554cbc0cd610765cd5'
says the commit is upstream since v3.7-rc1, and you backmerged v3.7-rc2
to drm-intel-next-queued with c2fb7916927e989ea424e61ce5fe617e54878827,
but the adjusted_mode fix is nowhere to be seen. Did something go wrong
with the backmerge, or am I missing something?


BR,
Jani.
