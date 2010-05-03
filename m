Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0ECVg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:36:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab0ECVg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:36:57 -0400
To: =?us-ascii?Q?=3D=3FISO-8859-15=3FQ=3FRonny=5FTsch=3DFCter=3F=3D?= 
	<Ronny.Tschueter@tu-dresden.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tracing of power:power_start events doesn't work
References: <4BDECD66.2010906@tu-dresden.de>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 03 May 2010 17:36:53 -0400
In-Reply-To: <4BDECD66.2010906@tu-dresden.de> (Ronny.Tschueter@tu-dresden.de's message of "Mon, 03 May 2010 15:19:34 +0200")
Message-ID: <y0msk68llai.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

=?ISO-8859-15?Q?Ronny_Tsch=FCter?= <Ronny.Tschueter@tu-dresden.de> writes:

> i use kernel version 2.6.33.2 (x86-64, Core 2 Duo) and the perf events
> to track frequency and c states of my cpu. But if i want to trace
> power:power_start events, it does not work. After typing
> echo "power:power_start" | sudo tee set_event
> on the console, the trace doesn't contain such
> events [...]

FWIW, on that kernel version (Fedora 13 on Athlon X2), systemtap hooks
into all those tracepoints fine, and

# stap -e 'probe kernel.trace("power_start") { log($$parms) }'

produces plenty of traffic.

- FChE
