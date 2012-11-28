Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2K1IPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:15:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:39036 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2K1IPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:15:31 -0500
Message-ID: <50B5C821.4000406@linutronix.de>
Date: Wed, 28 Nov 2012 09:15:29 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: Andrzej Pietrasiewicz <andrzej.p@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de> <xa1tip8ruia5.fsf@mina86.com>
In-Reply-To: <xa1tip8ruia5.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2012 05:23 PM, Michal Nazarewicz wrote:
> On Tue, Nov 27 2012, Sebastian Andrzej Siewior wrote:
>> I don't want to push python on anyone but the removal magic is simply
>> straight forward: unlink the disk ports, rmdir luns, tpgt,…
>
> How should a generic tool know what kind of actions are needed for given
> function to be removed?  If you ask me, there should be a way to unbind
> gadget and unload all modules without any specific knowledge of the
> functions.  If there is no such mechanism, then it's a bad user
> interface.

Well. You need only to remove the directories you created. An unbind
would be simply an unlink of the gadget which is linked to the udc.
All configurations remain so you can link it at a later point without
touching the configuration because it is as it was.

>> I understand the need for things that pop later like interfaceXX but
>> couldn't the user manually create them if he needs them?
>
> I think the question is of information flow direction.  If user gives
> some information to the kernel, she should be the one creating any
> necessary directories.  But if the information comes from kernel to the
> user, the kernel should create the structure.

Yes that is a point. But the "name" can go away if we use it in the
directory name. That is what other configfs user do. The same is true
for luns for instance. I just want to avoid adding features because we
do something different compared to every other configfs user.

Sebastian
