Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1DVJzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:55:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:53363 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618Ab1DVJzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:55:36 -0400
Date: Fri, 22 Apr 2011 11:55:34 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>,
        PenMount <penmount.touch@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: hid-multitouch: refactor last_field_index
In-Reply-To: <20110421124505.GA7916@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1104221154540.12035@pobox.suse.cz>
References: <1303388160-2814-1-git-send-email-benjamin.tissoires@enac.fr> <1303388160-2814-2-git-send-email-benjamin.tissoires@enac.fr> <20110421124505.GA7916@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Apr 2011, Henrik Rydberg wrote:

> > the current implementation requires the devices to report
> > HID_DG_CONTACTCOUNT to set the last_field_index value.
> > However, devices reporting in serial mode (DWAV and PenMount)
> > do not send this field.
> > Other devices (3M) add other fields in the reports descriptor
> > that are not multitouch related at the end, thus the need to
> > add a special case in the default case when handling events.
> > 
> > A first work around has been set up but with PenMount devices,
> > we have reached the limit.
> > 
> > The idea is to calculate the last_field_index by relying only on
> > multitouch fields the device send. This allows us to remove
> > the handling of non-multitouch events in hid-multitouch, and
> > guarantee that the function mt_emit_event is always called.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
> > ---
> 
> Reviewed-and-tested-by: Henrik Rydberg <rydberg@euromail.se>

Applied, thanks guys.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
