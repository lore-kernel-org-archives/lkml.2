Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab0DTBTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 21:19:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52320 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0DTBTE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 21:19:04 -0400
MIME-Version: 1.0
In-Reply-To: <20100420011302.GJ30801@buzzloop.caiaq.de>
References: <1271716024-22990-1-git-send-email-Dinh.Nguyen@freescale.com> 
	<1271716024-22990-2-git-send-email-Dinh.Nguyen@freescale.com> 
	<1271716024-22990-3-git-send-email-Dinh.Nguyen@freescale.com> 
	<1271716024-22990-4-git-send-email-Dinh.Nguyen@freescale.com> 
	<20100420011302.GJ30801@buzzloop.caiaq.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 19 Apr 2010 19:18:42 -0600
X-Google-Sender-Auth: 45a1a61b7809fe17
Message-ID: <y2gfa686aa41004191818o126cc59cs7b551103b91f2266@mail.gmail.com>
Subject: Re: [PATCHv5 2.6.34-rc4 4/5] mxc: Add generic USB HW initialization 
	for MX51
To: Daniel Mack <daniel@caiaq.de>
Cc: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       s.hauer@pengutronix.de, valentin.longchamp@epfl.ch,
       bryan.wu@canonical.com, amit.kucheria@canonical.com,
       r.herring@freescale.com, Jun.Li@freescale.com,
       xiao-lizhang@freescale.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 7:13 PM, Daniel Mack <daniel@caiaq.de> wrote:
> On Mon, Apr 19, 2010 at 05:27:03PM -0500, Dinh.Nguyen@freescale.com wrote:
>> +             /* allow controller to reset, and leave time for
>> +              * the ULPI transceiver to reset too.
>> +              */
>> +             msleep(100);
>
> Does the sleep really need to be that long? You're holding off the
> kernel's by that. If we can reduce that, we should certainly do so.

msleep() should be fine since Linux will schedule something else.
mdelay(100) would be bad indeed.

g.
