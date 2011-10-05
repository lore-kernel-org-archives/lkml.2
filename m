Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022Ab1JEIMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:12:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58164 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1JEIMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:12:54 -0400
MIME-Version: 1.0
In-Reply-To: <20111004232403.10364.22050.stgit@ponder>
References: <20111004232403.10364.22050.stgit@ponder>
Date: Wed, 5 Oct 2011 17:12:53 +0900
Message-ID: <CANqRtoTWach63ZgfLOs5c3UKoPo2F-kwe44OMpRqYvN_hmg+PA@mail.gmail.com>
Subject: Re: [RFC] drivercore: Add helper macro for platform_driver boilerplate
From: Magnus Damm <magnus.damm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: greg@kroah.com, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 8:26 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> For simple modules that contain a single platform_driver without any
> additional setup code then ends up being a block of duplicated
> boilerplate.  This patch adds a new macro, module_platform_driver(),
> which replaces the module_init()/module_exit() registrations with
> template functions.
>
> This patch also converts all the relevant spi drivers to use the new
> macro.  There are a lot of drivers in the tree that are using this
> pattern and could be converted.
>
> It also fixes up some incorrect section annotations where I found
> them.
>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>
> I think this is useful, and I like the diffstat that it produces.
> What does everyone else think of this approach?  I can do versions for
> i2c_drivers and spi_drivers too.

This is excellent, I've been wanting something like this forever!

Now the only thing left is dd.c not ignoring the ->remove() return
value - then I finally could sleep at night. I've seen that someone
has been poking around there and fixing the return values, nice to
see.

Thanks,

/ magnus
