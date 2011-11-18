Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab1KRAbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 19:31:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50649 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1KRAbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 19:31:34 -0500
MIME-Version: 1.0
In-Reply-To: <20111116203422.GA29581@legolas.emea.dhcp.ti.com>
References: <1321475279-29930-1-git-send-email-computersforpeace@gmail.com>
	<20111116203422.GA29581@legolas.emea.dhcp.ti.com>
Date: Thu, 17 Nov 2011 16:31:32 -0800
Message-ID: <CAN8TOE9T8YJ8Kbz=cuQ_CYPQozxU--yskZuBcXwe_emVVNQqDg@mail.gmail.com>
Subject: Re: [PATCH] ahci: platform support for suspend/resume
From: Brian Norris <computersforpeace@gmail.com>
To: balbi@ti.com
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Kevin Cernekee <cernekee@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+linux-pm mailing list

Hi Felipe,

On Wed, Nov 16, 2011 at 12:34 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Nov 16, 2011 at 12:27:59PM -0800, Brian Norris wrote:
>> +     /* Does platform support suspend/resume? */
>> +     if (!pdata->suspend || !pdata->resume)
>> +             return -EINVAL;
>
> should you really prevent suspend is platform doesn't provide
> ->suspend() ?

No, we shouldn't prevent suspend entirely; that would just be my
accidental side effect.

> I mean, we could some platform where all clocks are autogated and
> there's no need for platform to do anything. Would it be better to only
> call pdata->suspend if it exists but still let the AHCI-specific part go
> through ?

Perhaps. But would this have any unintended effects on systems that
don't implement AHCI power management at all? My intention was just to
provide an 'opt-in' interface for platform developers. I probably got
this wrong.

Brian
