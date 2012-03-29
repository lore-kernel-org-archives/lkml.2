Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656Ab2C2R0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 13:26:30 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:35489 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab2C2R0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 13:26:25 -0400
Date: Thu, 29 Mar 2012 19:26:19 +0200
From: Borislav Petkov <bp@amd64.org>
To: John Kacur <jkacur@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Remove a superfluous check
Message-ID: <20120329172618.GF6409@aftab>
References: <1333039463-24268-1-git-send-email-bp@amd64.org>
 <alpine.LFD.2.02.1203291902280.10113@tycho>
 <20120329171140.GE6409@aftab>
 <alpine.LFD.2.02.1203291914040.10113@tycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1203291914040.10113@tycho>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 07:17:19PM +0200, John Kacur wrote:

> It looks okay to me. Technically it's not functionally equivalent
> though, because now when __register_ftrace_function is called
> directly, (in other paths), the test has an unlikely there.

I know, but ftrace_disabled is really unlikely to be set to 1 because
we set it only if ftrace_init() fails and on the panic path in
ftrace_kill().

So I agree that it is not functionally completely equivalent but it
should be correct with the unlikely.

> See what teven says, otherwise, you can have my reviewed by.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
