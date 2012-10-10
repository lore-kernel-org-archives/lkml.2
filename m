Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab2JJO47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 10:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050Ab2JJO46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 10:56:58 -0400
Date: Wed, 10 Oct 2012 10:56:44 -0400
From: Dave Jones <davej@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: ODEBUG: free active (active state 0) object type: work_struct
 hint: flush_to_ldisc+0x0/0x1a0
Message-ID: <20121010145644.GA15843@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jiri Slaby <jirislaby@gmail.com>
References: <20121010042656.GA32075@redhat.com>
 <50752DC0.1090508@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50752DC0.1090508@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 10:11:44AM +0200, Jiri Slaby wrote:
 > On 10/10/2012 06:26 AM, Dave Jones wrote:
 > > Just hit this..
 > 
 > That'd be me perhaps. Do you have some serial device connected? Or is it
 > a pure terminals + ptys?

There's a usb serial tty connected. other than that, just regular ptys.

 > Did you do something special? This very smells

Box had been running fuzz testing for ~9 hours.
Unfortunatly because of another bug that still isn't fixed, I can't narrow
down the window yet.

 > like tty_port is being freed while flushing work_struct is still active.

The fuzzer forks multiple processes, so this sounds feasible.

	Dave

