Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab0C3LBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:01:46 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:46346 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756264Ab0C3LBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:01:43 -0400
Date: Tue, 30 Mar 2010 13:01:38 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net, j@jannau.net,
       jarod@redhat.com, jarod@wilsonet.com, kraxel@redhat.com,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org, superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR system?
Message-ID: <20100330110138.GA6164@hardeman.nu>
Mail-Followup-To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jon Smirl <jonsmirl@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	hermann pitton <hermann-pitton@arcor.de>,
	Christoph Bartelmus <lirc@bartelmus.de>, awalls@radix.net,
	j@jannau.net, jarod@redhat.com, jarod@wilsonet.com,
	kraxel@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	superm1@ubuntu.com
References: <9e4733910912151229o371ee017tf3640d8f85728011@mail.gmail.com>
 <20091215203300.GL24406@elf.ucw.cz>
 <9e4733910912151245ne442a5dlcfee92609e364f70@mail.gmail.com>
 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
 <4BAB7659.1040408@redhat.com>
 <20100326112755.GB5387@hardeman.nu>
 <4BACC769.6020906@redhat.com>
 <20100326160150.GA28804@core.coreip.homeip.net>
 <4BAFE4B7.2030204@redhat.com>
 <4BAFF985.3090703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4BAFF985.3090703@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 09:51:17PM -0300, Mauro Carvalho Chehab wrote:
> 
> I spoke too soon... removing the index causes a problem at the read ioctl: there's no way
> to retrieve just the non-sparsed values.
> 
> There's one solution that would allow both read/write and compat to work nicely,
> but the API would become somewhat asymmetrical:
> 
> At get (EVIOCGKEYCODEBIG):
> 	use index/len as input and keycode/scancode as output;
> 
> At set (EVIOCSKEYCODEBIG):
> 	use scancode/keycode/len as input (and, optionally, index as output).
> 

This was exactly the approach I had in mind when I suggested using 
indexes.

> Having it asymmetrical doesn't sound good, but, on the other hand, 
> using index for
> the set function also doesn't seem good, as the driver may reorder the entries after
> setting, for example to work with a binary tree or with hashes.

I don't think the assymetry is really a problem. As I see it, there are 
basically two user cases:

1) Userspace wants scancode X to generate keypress Y
   (In which case userspace doesn't care one iota what the index is)

2) Userspace wants to get the current keytable from the kernel
   (In which case a loop with an index from 0 to n is appropriate)

and, possibly:

3) Userspace wants to know what keycode (if any) scancode X generates
   (In which case approach 2 will work just as well, but this usecase
    seems a bit contrived anyway...)

-- 
David Härdeman
