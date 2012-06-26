Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab2FZSeR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:34:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46571 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126Ab2FZSeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:34:09 -0400
Date: Tue, 26 Jun 2012 11:34:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120626183405.GA2005@kroah.com>
References: <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com>
 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com>
 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop>
 <20120626165855.GA1851@kroah.com>
 <CAPXgP132AM9_3KryDc0cE+cKd-Q65wpGRkSzHaMvOGLM3AsrHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP132AM9_3KryDc0cE+cKd-Q65wpGRkSzHaMvOGLM3AsrHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 07:00:38PM +0200, Kay Sievers wrote:
> > Hm, this doesn't boot for me, just hangs at startup :(

Booting in a qemu image I get the following, it just hangs here:

[    2.683675] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
Started File System Check on Root Device                                [  OK  ]
Starting LSB: setup hostname and yp...
[    2.732973] systemd-fsck[108]: root: clean, 244481/1313280 files, 2189115/5242880 blocks
Starting Remount Root FS...
systemd-fsck[107]: root: clean, 244481/1313280 files, 2189115/5242880 blocks
[    2.746312] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr
Started Remount Root FS                                                 [  OK  ]
Starting Load Random Seed...
Started Load Random Seed                                                [  OK  ]
[    2.797945] boot.localnet[133]: Using boot-specified hostname 'pistachio.kroah.org'
boot.localnet[133]: Using boot-specified hostname 'pistachio.kroah.org'
[    2.898718] boot.localnet[133]: Setting up hostname 'pistachio'..done
boot.localnet[133]: Setting up hostname 'pistachio'..done
boot.localnet[    2.973681] boot.localnet[133]: Setting up loopback interface RTNETLINK answers: File exists
[133]: Setting up loopback interface RTNETLINK answers: File exists
boot.localnet[133]: ..done
[    2.979959] boot.localnet[108]: ..done
Started LSB: setup hostname and yp                                      [  OK  ]
Started Setup Virtual Console                                           [  OK  ]
[    3.056710] input: PC Speaker as /devices/platform/pcspkr/input/input3


any ideas?
