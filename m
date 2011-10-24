Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026Ab1JXRCc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 13:02:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755399Ab1JXRCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 13:02:30 -0400
Subject: Re: Linux USB HID should ignore values outside Logical
 Minimum/Maximum range
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Denilson Figueiredo de =?ISO-8859-1?Q?S=E1?= 
	<denilsonsa@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <op.v3q34la3dsdv5o@localhost>
References: <op.v3q34la3dsdv5o@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Oct 2011 19:09:43 +0200
Message-ID: <1319476183.3210.12.camel@lovely>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denilson,

 please see my comment below.

On Sat, 2011-10-22 at 09:42 -0200, Denilson Figueiredo de Sá wrote:
> Short description:
> 
> An absolute pointing device using USB HID defines a LOGICAL_MINIMUM and
> a LOGICAL_MAXIMUM for X, Y axes, and then sends a HID report containing
> values outside that range.
> 
> Linux kernel should ignore values outside that range, as they are not
> meaningful.

To answer with a quote from the comment above input.h:"struct
input_absinfo":

 *
 * Note that input core does not clamp reported values to the
 * [minimum, maximum] limits, such task is left to userspace.
 *

to do so, use this from input.h:

#define EVIOCGABS(abs)		_IOR('E', 0x40 + (abs), struct input_absinfo)	/* get abs value/limits */
#define EVIOCSABS(abs)		_IOW('E', 0xc0 + (abs), struct input_absinfo)	/* set abs value/limits */


> <SNIP>

Thanks,
 -- chf


