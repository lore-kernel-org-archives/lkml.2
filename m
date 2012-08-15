Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2HOQQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 12:16:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55069 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185Ab2HOQQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 12:16:20 -0400
Message-ID: <502BCB4A.5050002@zytor.com>
Date: Wed, 15 Aug 2012 09:16:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>
Subject: Re: Q: On restoring terminal with hinted index
References: <20120815152504.GG23657@moon>
In-Reply-To: <20120815152504.GG23657@moon>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 08:25 AM, Cyrill Gorcunov wrote:
> Hi Peter,
> 
> that happened that in a sake of restoring ptys after checkpoint
> we need to create them with predefined indices, as they were at
> moment of dumping. So we have two options -- 1) Open terminals
> in sequence until needed index reached 2) Use some other way to
> say the kernel that some index is preferred.
> 
> So I thought, would it be acceptible to provide such hint via
> sysctl, as in patch below (note I've not even compiled it yet,
> but would like to know your opinion early).
> 
> (Maybe even make it one shot, thus once ida_get_new_above called
>  the pty_next reset to zero).
> 

Pardon me while I vomit... an interaction between sysctl and open?  Talk
about a race condition from hell.  It is stateful, and not connected to
the filesystem instance that it is supposed to be affecting.  So no,
please don't.  I understand your objective but it really needs to be
something attached to the pts filesystem instance in question.

	-hpa
