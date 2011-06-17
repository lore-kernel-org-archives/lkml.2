Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab1FQSUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:20:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64580 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab1FQSUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:20:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ighUL2727UjDIibFUqCJcwMRs0s6YR4xlBIharZLceofsdCdnewxEmHYLPXBN3M3Cl
         KV7hGqb0GPXe1mDNcA3PilBCLxxwaD5/QPebgFWTPgQ6gJu4w8jRFNnU1BccimsNWvPR
         6rHjXNNd8De1OAE2h6Zpxb53xlvOGLAC2Hsek=
MIME-Version: 1.0
In-Reply-To: <87zklgnyj0.fsf@eliezer.anholt.net>
References: <1308328920-2068-1-git-send-email-daniel.blueman@gmail.com>
	<87zklgnyj0.fsf@eliezer.anholt.net>
Date: Sat, 18 Jun 2011 02:20:08 +0800
Message-ID: <BANLkTimKKcW3yfDBF2ahYag+kKvdMaA7Mw@mail.gmail.com>
Subject: Re: [PATCH 3.0-rc3, v2] i915: Fix gen6 (SNB) GPU stalling
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Eric Anholt <eric@anholt.net>
Cc: Dave Airlie <airlied@redhat.com>, Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Widawsky <ben@bwidawsk.net>,
        Kenneth Graunke <kenneth@whitecape.org>, Yi Sun <yi.sun@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Mengmeng Meng <mengmeng.meng@intel.com>,
        Robert Hooker <sarvatt@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 June 2011 01:44, Eric Anholt <eric@anholt.net> wrote:
> On Sat, 18 Jun 2011 00:42:00 +0800, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
>> Workaround Sandy Bridge GPU stalls by allowing the blitter command streamer
>> to write interrupt state to the Hardware Status Page when a MI_USER_INTERRUPT
>> command is decoded.
>>
>> v1->v2: Moved to prior interrupt handler installation and RMW flags as per
>> feedback.
>
> We shouldn't be RMWing.  We're the driver, we're supposed to know what
> we want.  I'm backing that bit out, will do another round of testing,
> and send it off.

I still prefer directly setting the mask due to my earlier reasons.
Unmasking in the IRQ preinstall tests good here, so I'll send a v3
patch in the morning.

Thanks,
  Daniel
-- 
Daniel J Blueman
