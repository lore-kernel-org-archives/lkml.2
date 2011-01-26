Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab1AZPdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 10:33:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424Ab1AZPdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:33:13 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101261004560.8580@xanadu.home>
References: <20110125.194532.71125517.davem@davemloft.net> <1296019325-17801-1-git-send-email-thomas@wytron.com.tw>
 <alpine.LFD.2.00.1101261004560.8580@xanadu.home>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jan 2011 08:32:52 -0700
X-Google-Sender-Auth: 9zMMKDbYWOj-hAE3-SlhXcN8bvg
Message-ID: <AANLkTimCMpB+mOHv+8GMOkFF0qMh+bVxr56_-8r3EOqc@mail.gmail.com>
Subject: Re: [PATCH v4] smc91x: add devicetree support
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Thomas Chou <thomas@wytron.com.tw>, David Miller <davem@davemloft.net>,
        lkml <linux-kernel@vger.kernel.org>, nios2-dev@sopc.et.ntust.edu.tw,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 8:17 AM, Nicolas Pitre <nico@fluxnic.net> wrote:
> On Wed, 26 Jan 2011, Thomas Chou wrote:
>
>> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
>> ---
>> v2 specify part numbers in compat as Grant suggested.
>> v3 more specific part name.
>> v4 include match table only for OF as David suggested.
>
> The smc91x driver relies on many parameters which are platform specific,
> such as the bus width capabilities, register spacing due to special bus
> wiring, interrupt signal level, LED configuration, whether or not to
> configure the chip with a wait state, etc.  Will the device tree support
> take care of those things?

Short answer, yes

In general bindings are written and documented as they are needed.  In
this specific case,yes the device configuration should be encoded into
the device tree node.  It is okay for now to not wire up any of that
configuration if the defaults work for Thomas' platform, but to be
useful in the long run they do need to be added.

Typically a block or function call is added to the drivers .probe hook
to decode device tree data if the of_node pointer is set.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
