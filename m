Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab1KBTH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:07:59 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41978 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab1KBTH6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:07:58 -0400
MIME-Version: 1.0
In-Reply-To: <yunobwuuzha.fsf@aiko.keithp.com>
References: <1320214830-12696-1-git-send-email-keithp@keithp.com>
	<1320214830-12696-4-git-send-email-keithp@keithp.com>
	<yunobwuuzha.fsf@aiko.keithp.com>
Date: Wed, 2 Nov 2011 15:07:57 -0400
Message-ID: <CADnq5_O82QYfK9Dh+Rb41Ranstok+RSAg4UxY+6gDXeXTeu0Mw@mail.gmail.com>
Subject: Re: [PATCH 3/7] drm/i915: Treat PCH eDP like DP in most places
From: Alex Deucher <alexdeucher@gmail.com>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 2:54 PM, Keith Packard <keithp@keithp.com> wrote:
> On Tue,  1 Nov 2011 23:20:26 -0700, Keith Packard <keithp@keithp.com> wrote:
>
>>               intel_dp = enc_to_intel_dp(encoder);
>> -             if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT) {
>> +             if (intel_dp->base.type == INTEL_OUTPUT_DISPLAYPORT || is_pch_edp(intel_dp)) {
>>                       lane_count = intel_dp->lane_count;
>>                       break;
>> -             } else if (is_edp(intel_dp)) {
>> +             } else if (is_cpu_edp(intel_dp)) {
>>                       lane_count = dev_priv->edp.lanes;
>>                       break;
>
> Thinking about this one more time -- if we ever want to use
> dev_priv->edp.lanes, we should use it in
> intel_dp_max_lane_count. intel_dp_set_m_n should use
> intel_dp->lane_count unconditionally as that's the value we've used
> everywhere else for mode setting.
>
> Perhaps we should use it for monitors that don't include the
> MAX_LANE_COUNT field in the dpcd? Perhaps we should use it on all eDP
> monitors?

FWIW, we rely on the DPCD field for eDP just like DP.  Our vbios LCD
tables don't contain DP lane or rate info.

Alex
