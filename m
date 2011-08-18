Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab1HRQBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 12:01:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab1HRQBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 12:01:44 -0400
Message-ID: <4E4D3763.7000402@canonical.com>
Date: Thu, 18 Aug 2011 09:01:39 -0700
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com
Subject: Re: [PATCH 6/9 v4] Input: mt - document devices reporting more touches
 than slots
References: <1313666888-18939-1-git-send-email-djkurtz@chromium.org> <1313666888-18939-7-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1313666888-18939-7-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2011 04:28 AM, Daniel Kurtz wrote:
> Some devices are capable of identifying and/or tracking more contacts than
> they can report to the driver.  Document how a driver should handle this,
> and what userspace should expect.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  Documentation/input/multi-touch-protocol.txt |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
> index 71536e7..543101c 100644
> --- a/Documentation/input/multi-touch-protocol.txt
> +++ b/Documentation/input/multi-touch-protocol.txt
> @@ -65,6 +65,20 @@ the full state of each initiated contact has to reside in the receiving
>  end.  Upon receiving an MT event, one simply updates the appropriate
>  attribute of the current slot.
>  
> +Some devices identify and/or track more contacts than they can report to the
> +driver.  A driver for such a device should associate one type B slot with each
> +contact that is reported by the hardware.  Whenever the identity of the
> +contact associated with a slot changes, the driver should invalidate that
> +slot by changing its ABS_MT_TRACKING_ID.  If the hardware signals that it is
> +tracking more contacts than it is currently reporting, the driver should use
> +a BTN_TOOL_*TAP event to inform userspace of the total number of contacts
> +being tracked by the hardware at that moment.  The driver should do this by
> +explicitly sending the corresponding BTN_TOOL_*TAP event and setting
> +use_count to false when calling input_mt_report_pointer_emulation().
> +The driver should only advertise as many slots as the hardware can report.
> +Userspace can detect that a driver can report more total contacts than slots
> +by noting that the largest supported BTN_TOOL_*TAP event is larger than the
> +total number of type B slots reported in the absinfo for the ABS_MT_SLOT axis.
>  
>  Protocol Example A
>  ------------------

Acked-by: Chase Douglas <chase.douglas@canonical.com>

Thanks a bunch Daniel!
