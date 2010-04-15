Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab0DOU5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 16:57:47 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50951 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab0DOU5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 16:57:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v+OQ7IKUVI0U3OhNxJCP4Cw58hz2KGBeqP3xXlJ3T0r44rocoLXfErSFq3zFalHMXj
         0OaSmyStt9TLoHSMXeKuaHUPWfEbxC8gZ2sm4sRMewTHJ9t9kMT+tXOjtbz6QZvwIfHa
         BrkUJPd1jgSV5DsVIqS3cWOxFOJz1ztsF+iTM=
Date: Thu, 15 Apr 2010 22:57:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/3] Add tracing_off_event() calls to BUG() and WARN()
	paths
Message-ID: <20100415205739.GF5069@nowhere>
References: <1271262016-18650-1-git-send-email-chase.douglas@canonical.com> <1271262016-18650-2-git-send-email-chase.douglas@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271262016-18650-2-git-send-email-chase.douglas@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 12:20:15PM -0400, Chase Douglas wrote:
> This change adds tracing_off_event() calls, which stop debug tracing,
> when a BUG() or WARN() function is called. The stoppage depends on
> commandline paramenter tracing_off={bug,warn,none}. The default is
> "bug", so only the BUG() paths will stop tracing.
> 
> Signed-off-by: Chase Douglas <chase.douglas@canonical.com>


ACK

But I can't find where we call oops_enter() from panic()
I see it called in x86 from oops_begin() that is called
in various places like die(), but couldn't find how it
ends up beeing called from panic().

