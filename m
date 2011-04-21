Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1DUMnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 08:43:16 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:37363 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1DUMnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 08:43:15 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiBRAMglsE1V5qkTPGdsb2JhbACJGpwuCwEBAQE3MsQsDoVoBJI8gkc
X-IronPort-AV: E=Sophos;i="4.64,251,1301868000"; 
   d="scan'208";a="183326070"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 21 Apr 2011 14:45:05 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>,
        PenMount <penmount.touch@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: hid-multitouch: refactor last_field_index
Message-ID: <20110421124505.GA7916@polaris.bitmath.org>
References: <1303388160-2814-1-git-send-email-benjamin.tissoires@enac.fr>
 <1303388160-2814-2-git-send-email-benjamin.tissoires@enac.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303388160-2814-2-git-send-email-benjamin.tissoires@enac.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 02:15:59PM +0200, Benjamin Tissoires wrote:
> the current implementation requires the devices to report
> HID_DG_CONTACTCOUNT to set the last_field_index value.
> However, devices reporting in serial mode (DWAV and PenMount)
> do not send this field.
> Other devices (3M) add other fields in the reports descriptor
> that are not multitouch related at the end, thus the need to
> add a special case in the default case when handling events.
> 
> A first work around has been set up but with PenMount devices,
> we have reached the limit.
> 
> The idea is to calculate the last_field_index by relying only on
> multitouch fields the device send. This allows us to remove
> the handling of non-multitouch events in hid-multitouch, and
> guarantee that the function mt_emit_event is always called.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> ---

Reviewed-and-tested-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
