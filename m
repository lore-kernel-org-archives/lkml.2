Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab2KLL3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 06:29:37 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:38039 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752467Ab2KLL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 06:29:35 -0500
Subject: Re: [RFC] Device Tree Overlays Proposal (Was Re: capebus moving omap_devices to mach-omap2)
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CACxGe6vTJHvZwZ383DE5-k+ksv1nGeuLynADuQC+D2eySj7gWQ@mail.gmail.com>
Date: Mon, 12 Nov 2012 13:29:28 +0200
Cc: Mitch Bradley <wmb@firmworks.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kevin Hilman <khilman@ti.com>, Matt Porter <mporter@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Deepak Saxena <dsaxena@linaro.org>,
        Scott Wood <scottwood@freescale.com>, Russ Dill <Russ.Dill@ti.com>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <53E5CE97-0CA5-416A-BC57-01B6A7C87973@antoniou-consulting.com>
References: <CACxGe6vu8ek7-K-yDDMXyg9x-oKiFt_cSz+Pz-yZf5U5vwe=0g@mail.gmail.com> <50999145.2070306@wwwdotorg.org> <5099B150.7070808@firmworks.com> <CACxGe6vTJHvZwZ383DE5-k+ksv1nGeuLynADuQC+D2eySj7gWQ@mail.gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Nov 9, 2012, at 7:02 PM, Grant Likely wrote:

> On Wed, Nov 7, 2012 at 12:54 AM, Mitch Bradley <wmb@firmworks.com> wrote:
>> On 11/6/2012 12:37 PM, Stephen Warren wrote:
>>> This proposal is very oriented at an overlay-based approach. I'm not
>>> totally convinced that a pure overlay approach (as in how dtc does
>>> overlayed DT nodes) will be flexible enough, but would love to be
>>> persuaded. Again see below.
>> 
>> 
>> An overlay approach will not be powerful enough to solve the sorts of
>> problems that occur when a product goes into full production, becomes a
>> family, and starts to evolve.  Issues like second-source parts that
>> aren't quite compatible and need to be detected and reported,
>> board-stuff options for different customer profiles, speed grades of
>> parts that aren't properly probeable but instead need to be identified
>> by some subterfuge, the list of tedious issues goes on and on.
>> 
>> It's nice to pretend that the world fits into a few coherent simple
>> use cases, but 30 years of experience shipping computer product families
>> proves otherwise.  You need a programming language to solve the full
>> set of problems - which I why the device tree is designed so it can
>> be generated and modified by a program.
> 
> I'm not going to argue with that. There is nothing saying that the
> overlay wouldn't be generated or applied by a script. However, I do
> strongly think that the data model needs to be independent of any tool
> or execution environment used to manipulate it. I certainly am not
> interested in encoding scripts or bytecode into the tree - the
> opposite of the approach used by ACPI which must execute AML to even
> retrieve the device tree. I like the overlay approach because it is
> conceptually straightforward and provides a working model of how
> changes could be made from userspace while still being usable by
> firmware.
> 
> An alternate approach from userspace would be to use a live virtual
> filesystem to manipulate the device tree, though that approach only
> applies to Linux userspace. Firmware would still need its own
> approach.
> 
> g.

I completely agree here. 

I certainly wouldn't want to introduce any kind of bytecode or a
programming model for manipulating DT. I know OF has a full blown
forth interpreter, but that's not what modern DT should be (IMHO).

Having DT provide such a programming model will preclude a number
of users of accessing it, and on top of that, complexity will 
increase considerably. 

When faced with a new problem, vendors will just code a workaround, 
never bothering fixing it properly.

In a nutshell, let's not turn DT into ACPI, please.

Regards

-- Pantelis



