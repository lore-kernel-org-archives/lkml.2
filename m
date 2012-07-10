Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab2GJQny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:43:54 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:57282 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753999Ab2GJQnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:43:51 -0400
Subject: Re: [PATCH] rpmsg bus subsys_initcall initialization ordering
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
From: Federico Fuga <fuga@studiofuga.com>
In-Reply-To: <CAK=Wgbaf0On3teqOw1myqkS4Dei3Vw2Zn=0xfOv-YiNUjFr0fg@mail.gmail.com>
Date: Tue, 10 Jul 2012 18:43:35 +0200
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <485F7F7C-2D0C-4B14-8A46-D42C9F8ED4E4@studiofuga.com>
References: <1341936444-3094-1-git-send-email-fuga@studiofuga.com> <CAK=Wgbaf0On3teqOw1myqkS4Dei3Vw2Zn=0xfOv-YiNUjFr0fg@mail.gmail.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
X-Mailer: Apple Mail (2.1278)
X-Identified-User: {2354:box484.bluehost.com:happycac:studiofuga.com} {sentby:smtp auth 95.241.194.105 authed with fuga+studiofuga.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

Il giorno 10/lug/2012, alle ore 18:22, Ohad Ben-Cohen ha scritto:

> On Tue, Jul 10, 2012 at 7:07 PM, Federico Fuga <fuga@studiofuga.com> wrote:
>> omaprpc depends on the rpmsg bus.
> 
> Sorry for the ignorance, but what's omaprpc ? :)
> 


You're right, I should have explained this! :-)
omaprpc is the Omap Remote Procedure Call driver. Quoting the Kconfig file,

"An rpmsg driver that exposes the Remote Procedure Call API to User Space, in order to allow applications to distribute remote call to more power efficient remote processors on OMAP4+ systems".

It depends on rpmsg system.

> I guess it's some out-of-tree module (which I've never seen) so I'm
> not sure we want change mainline code to fix issues with it.
> 

omaprpc is out of the official mainline code, it's inside the official ti/omap branch/project.
I guessed that the easier solution had been to change the initialization level, in a similar way it's done by the i2c bus driver for example.
I don't know if this is the best solution to solve this, maybe the problem could be solved in the omaprpc driver (maybe this could be the right solution).


> If your code is anyway out-of-tree, it'd probably make more sense if
> this patch stays out of tree too (plus I have no way to review this
> patch, and understand the issue it fixes, without seeing the relevant
> code).
> 
> If this really is about mainline kernel, let me know.
> 

Really, I don't have enough experience to say if it should be solved this way or not. For what I can see, this seems absolutely logic that busses are initialized before other drivers, so subsys_initcall should be perfectly logic. But I don't have the complete view of the system, so I could be wrong.
On the other hand, I didn't find another way to solve this dependency problem. I know there is also a Makefile approach, but the dependent driver (omaprpc) is in the staging driver directory, so I think is not feasible.
Any other solution?

Thanks

Federico



