Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085Ab1KBUgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:36:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab1KBUfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:35:55 -0400
Message-ID: <4EB1A9A7.8070900@redhat.com>
Date: Wed, 02 Nov 2011 16:35:51 -0400
From: Adam Jackson <ajax@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most
 places
References: <1320214830-12696-1-git-send-email-keithp@keithp.com> <1320214830-12696-4-git-send-email-keithp@keithp.com> <20111102092019.3a635632@jbarnes-desktop> <4EB17A50.6050804@redhat.com> <yun8vnywhvh.fsf@aiko.keithp.com> <4EB19BB4.6030505@redhat.com> <yunipn2uw70.fsf@aiko.keithp.com>
In-Reply-To: <yunipn2uw70.fsf@aiko.keithp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/11 4:05 PM, Keith Packard wrote:
> On Wed, 02 Nov 2011 15:36:20 -0400, Adam Jackson<ajax@redhat.com>  wrote:
>
>> The VBT is going to be crap.
>
> The only question then is what to do with hardware that doesn't have the
> DPCD value -- that's "new" in revision 0x11, after all.

It is?  The DP 1.1a text for lane count is "For Rev.1.1, only the 
following three values are supported. All other values are reserved."  I 
don't think that implies anything about what it meant in 1.0.  It does 
say that bits 7:5 of that register are reserved in 1.0 though; since it 
doesn't have any versioning on bits 4:0 I'd think that means they're 
interpreted the same in 1.0 as in 1.1.

Unless you have a copy of the 1.0 spec?

Again, not that it probably matters much.  I think the installed base of 
DP 1.0 sinks is zero, I've literally never seen one.

> How about this:
>
> commit 34ebe02cc78f20ae6b7865c5087c3b5ac7810185
> Author: Keith Packard<keithp@keithp.com>
> Date:   Wed Nov 2 13:03:47 2011 -0700
>
>      drm/i915: Use DPCD value for max DP lanes where possible
>
>      Fall back to the VBT value for eDP monitors only when DPCD is missing
>      the value.
>
>      Signed-off-by: Keith Packard<keithp@keithp.com>

Reviewed-by: Adam Jackson <ajax@redhat.com>

- ajax
