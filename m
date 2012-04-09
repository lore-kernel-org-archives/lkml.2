Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2DIBqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 21:46:31 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60001 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2DIBq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 21:46:29 -0400
MIME-Version: 1.0
In-Reply-To: <1333927151-13014-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1333927151-13014-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Sun, 8 Apr 2012 21:46:28 -0400
Message-ID: <CAGoCfixO1mUO0VGBL9GzOmaWpQ6rVos095reFfUWnVwCj0CyYg@mail.gmail.com>
Subject: Re: [PATCH] media: au0828: Convert BUG_ON to WARN_ONCE
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jrh <jharbestonus@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 7:19 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In the mail thread at http://www.mythtv.org/pipermail/mythtv-users/2012-April/331164.html,
> a kernel crash is triggered when trying to run mythtv with a HVR950Q tuner.
> The crash condition is due to res_free() being called to free something that
> has is not reserved. The actual reason for this mismatch of reserve/free is
> not known; however, using a BUG_ON rather than a WARN_ON seems unfortunate.

This patch should be nack'd.  The real reason should be identified,
and a patch should be submitted for that (and from what I gather, it
seems like it is easily reproduced by the submitter).  Just add a few
"dump_stack()" calls in the res_get() and res_free() calls to identify
the failing call path.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
