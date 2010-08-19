Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab0HSPoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:44:34 -0400
Received: from mx1.sophos.com ([195.166.81.52]:48571 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab0HSPod convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:44:33 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Andreas Schwab <schwab@linux-m68k.org>
Subject: Re: struct fanotify_event_metadata
Date: Thu, 19 Aug 2010 16:44:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Andreas Gruenbacher <agruen@suse.de>, Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <m21va1ozqx.fsf@igel.home>
In-Reply-To: <m21va1ozqx.fsf@igel.home>
MIME-Version: 1.0
Message-ID: <201008191644.29299.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/08/2010 16:44:29,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 19/08/2010 16:44:30,
	Serialize complete at 19/08/2010 16:44:30
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 Aug 2010 18:44:38 Andreas Schwab wrote:
> The pid field of struct fanotify_event_metadata has 64 bits which looks
> excessive.  Wouldn't it make sense to make it 32 bits and swap it with
> the mask field?  That would avoid the unaligned mask field, and remove
> the need for the packed attribute.

No one seems to have picked up on this what I thought was an obvious good
idea.

So yes, 32-bit PID makes sense I think. If that was changed, would removing
the packed attribute get us anything more? If not it may stay for extra safety
if/when new fields are added.

Also, would it make sense to move mask in front of fd so 32-bit pid can stay
at the end? I think mask logically should be higher because is the more meta
data, while pid is auxiliary.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
