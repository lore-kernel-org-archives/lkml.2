Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab0HLShF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 14:37:05 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:44105 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760735Ab0HLShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 14:37:03 -0400
Date: Thu, 12 Aug 2010 14:36:59 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: walt <w41ter@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis>
Subject: Re: [BISECTED] Removing BKL causes stack trace during early bootup
Message-ID: <20100812183659.GA24008@elliptictech.com>
Mail-Followup-To: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis>
References: <4C6438BF.9070608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6438BF.9070608@gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-12 11:09 -0700, walt wrote:
> The trace whizzes by so fast that I can't read it, and the trace doesn't appear
> in any of the logs.  Is there a way to capture such a trace, like maybe changing
> it to a fatal error?

There are a couple options.  First, the message _should_ appear in
'dmesg' output since you say the system boots: however if there was a
lot of _other_ output it is possible that it got pushed off the end of
the log.  In this case, the easiest way to get it is to simply increase
the log buffer size, CONFIG_LOG_BUF_SHIFT, found under 'General Setup'
in menuconfig.

Another option is to use a serial console or netconsole to capture the
output on another machine.

Yet another option is to use the kernel command line option, boot_delay,
which lets you slow down the printing of messages at boot.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
