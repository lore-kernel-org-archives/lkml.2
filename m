Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2FPGQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 02:16:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56692 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab2FPGQx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 02:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <1339826500.9220.224.camel@pasglop>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
 <1339822897-15840-9-git-send-email-grant.likely@secretlab.ca> <1339826500.9220.224.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Sat, 16 Jun 2012 00:16:32 -0600
X-Google-Sender-Auth: 2GoCJYjARkjvXgWjEmoEJ2YoaY8
Message-ID: <CACxGe6v_nz5pw8xjcy2-ewcZehY_KO0tgRO7=DtWOJS-e5uXMg@mail.gmail.com>
Subject: Re: [PATCH 08/12] irqdomain: Replace LEGACY mapping with LINEAR
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>, Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 12:01 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Fri, 2012-06-15 at 23:01 -0600, Grant Likely wrote:
>> The LEGACY mapping unnecessarily complicates the irqdomain code and
>> can easily be implemented with a linear mapping.  By ripping it out
>> and replacing it with the LINEAR mapping the object size of
>> irqdomain.c shrinks by about 330 bytes (ARMv7) which offsets the
>> additional allocation required by the linear map.  It also makes it
>> possible for current LEGACY map users to pre-allocate irq_descs for a
>> subset of the hwirqs and dynamically allocate the rest as needed.
>
> The point of legacy was to reserve 0...15, they could only be handed out
> to that controller, that guarantees that ancient crap x86 drivers with
> hard coded irq numbers would fail ... unless you have an x86-style
> chipset (PReP, some CHRP, ...).
>
> I'd like to keep that functionality a way or another.

The functionality is still entirely there; it's just implemented with
a linear map that gets populated with mappings to reserved irqs.
Everything *should* keep working correctly.

g.
